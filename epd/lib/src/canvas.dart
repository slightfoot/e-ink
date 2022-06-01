import 'dart:typed_data';

import 'package:charcode/ascii.dart';
import 'package:epd/src/fonts.dart';
import 'package:epd/src/image.dart';

/// Canvas rotation
enum EpdRotation {
  rotate0,
  rotate90,
  rotate180,
  rotate270,
}

/// Canvas
///
/// Note: this can be optimized a lot by using shift tables and bitwise operators (coming soon)
class EpdCanvas extends EpdImage {
  EpdCanvas(
    int width,
    this.height, {
    this.rotation = EpdRotation.rotate0,
    this.inverted = false,
  }) {
    // 1 byte = 8 pixels, so the width should be the multiple of 8
    this.width = width % 8 != 0 ? width + 8 - (width % 8) : width;
    length = width ~/ 8 * height;
    _image = Uint8List(length);
    if (inverted) {
      _image.fillRange(0, length, 0xff);
    }
  }

  @override
  late final int width;

  @override
  late final int height;

  @override
  List<int> get image => List.unmodifiable(_image);

  late final Uint8List _image;
  late final int length;
  final EpdRotation rotation;
  final bool inverted;

  /// returns true if the point should be clipped
  bool _clipPoint(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return true;
    }
    return false;
  }

  /// clear the canvas
  void clear({bool colored = false}) {
    late final int value;
    if (inverted) {
      value = (colored) ? 0x00 : 0xff;
    } else {
      value = (colored) ? 0xff : 0x00;
    }
    _image.fillRange(0, length, value);
  }

  /// used to set a pixel in the frame-buffer
  void _drawPixelInternal(int x, int y, bool colored) {
    final offset = ((y * width) + x) ~/ 8;
    if (inverted) {
      if (colored) {
        _image[offset] &= ~(0x80 >> (x % 8));
      } else {
        _image[offset] |= (0x80 >> (x % 8));
      }
    } else {
      if (colored) {
        _image[offset] |= (0x80 >> (x % 8));
      } else {
        _image[offset] &= ~(0x80 >> (x % 8));
      }
    }
  }

  /// this draws a pixel [colored] at absolute coordinates ([x],[y])
  /// this function won't be affected by the [rotation].
  void drawPixelAbsolute(int x, int y, bool colored) {
    // Clip to canvas
    if (_clipPoint(x, y)) {
      return;
    }
    _drawPixelInternal(x, y, colored);
  }

  /// this draws a pixel [colored] at the coordinates ([x],[y])
  void drawPixel(int x, int y, bool colored) {
    // Clip to canvas
    if (_clipPoint(x, y)) {
      return;
    }
    switch (rotation) {
      case EpdRotation.rotate0:
        _drawPixelInternal(x, y, colored);
        break;
      case EpdRotation.rotate90:
        _drawPixelInternal(width - y, x, colored);
        break;
      case EpdRotation.rotate180:
        _drawPixelInternal(width - x, height - y, colored);
        break;
      case EpdRotation.rotate270:
        _drawPixelInternal(y, height - x, colored);
        break;
    }
  }

  /// this draws a character glyph on the frame buffer
  void drawGlyph(int x, int y, int char, EpdFont font, bool colored) {
    // skip control characters and spaces
    if (char <= $space) {
      return;
    }
    int offset = (char - $space) * font.height * (font.width ~/ 8 + (font.width % 8 != 0 ? 1 : 0));
    for (int yd = 0; yd < font.height; yd++) {
      for (int xd = 0; xd < font.width; xd++) {
        if ((font.data[offset] & (0x80 >> (xd % 8))) != 0) {
          drawPixel(x + xd, y + yd, colored);
        }
        if ((xd % 8) == 7) {
          offset++;
        }
      }
      if ((font.width % 8) != 0) {
        offset++;
      }
    }
  }

  /// this draws a string on the frame buffer
  void drawText(int x, int y, String text, EpdFont font, bool colored) {
    for (final char in text.codeUnits) {
      drawGlyph(x, y, char, font, colored);
      x += font.width; // monospace :(
    }
  }

  /// measures the text and returns the overall width (monospace only)
  int measureText(String text, EpdFont font) {
    return (font.width * text.codeUnits.length);
  }

  /// this draws a [colored] line on the frame buffer
  /// from ([x0],[y0]) - ([x1],[y1])
  void drawLine(int x0, int y0, int x1, int y1, bool colored) {
    if (x0 == x1) {
      drawVerticalLine(x0, y0, y1, colored);
      return;
    } else if (y0 == y1) {
      drawHorizontalLine(x0, y0, x1, colored);
      return;
    }
    // Bresenham's line algorithm
    final dx = (x1 - x0).abs();
    final sx = x0 < x1 ? 1 : -1;
    final dy = -((y1 - y0).abs());
    final sy = y0 < y1 ? 1 : -1;
    int error = dx + dy;
    while (true) {
      drawPixel(x0, y0, colored);
      if (x0 == x1 && y0 == y1) break;
      int e2 = 2 * error;
      if (e2 >= dy) {
        if (x0 == x1) break;
        error = error + dy;
        x0 = x0 + sx;
      }
      if (e2 <= dx) {
        if (y0 == y1) break;
        error = error + dx;
        y0 = y0 + sy;
      }
    }
  }

  /// this draws a [colored] horizontal line on the frame buffer
  /// from ([x],[y]) - ([x1], [y])
  void drawHorizontalLine(int x, int y, int x1, bool colored) {
    final start = (x < x1) ? x : x1;
    final end = (x < x1) ? x1 : x;
    for (int dx = start; dx < end; dx++) {
      drawPixel(dx, y, colored);
    }
  }

  /// this draws a [colored] vertical line on the frame buffer
  /// from ([x],[y]) - ([x], [y1])
  void drawVerticalLine(int x, int y, int y1, bool colored) {
    final start = (y < y1) ? y : y1;
    final end = (y < y1) ? y1 : y;
    for (int dy = start; dy < end; dy++) {
      drawPixel(x, dy, colored);
    }
  }

  /// this draws a rectangle
  void drawRectangle(int x0, int y0, int x1, int y1, bool colored) {
    int minX, minY, maxX, maxY;
    minX = x1 > x0 ? x0 : x1;
    maxX = x1 > x0 ? x1 : x0;
    minY = y1 > y0 ? y0 : y1;
    maxY = y1 > y0 ? y1 : y0;
    drawHorizontalLine(minX, minY, maxX, colored);
    drawHorizontalLine(minX, maxY, maxX, colored);
    drawVerticalLine(minX, minY, maxY, colored);
    drawVerticalLine(maxX, minY, maxY, colored);
  }

  /// this draws a filled rectangle
  void drawFilledRectangle(int x0, int y0, int x1, int y1, bool colored) {
    int minX, minY, maxX, maxY;
    minX = x1 > x0 ? x0 : x1;
    maxX = x1 > x0 ? x1 : x0;
    minY = y1 > y0 ? y0 : y1;
    maxY = y1 > y0 ? y1 : y0;
    for (int i = minX; i <= maxX; i++) {
      drawVerticalLine(i, minY, maxY, colored);
    }
  }

  /// this draws a circle
  void drawCircle(int x, int y, int radius, bool colored) {
    // Bresenham's algorithm
    int xPos = -radius;
    int yPos = 0;
    int err = 2 - 2 * radius;
    int e2;
    do {
      drawPixel(x - xPos, y + yPos, colored);
      drawPixel(x + xPos, y + yPos, colored);
      drawPixel(x + xPos, y - yPos, colored);
      drawPixel(x - xPos, y - yPos, colored);
      e2 = err;
      if (e2 <= yPos) {
        err += ++yPos * 2 + 1;
        if (-xPos == yPos && e2 <= xPos) {
          e2 = 0;
        }
      }
      if (e2 > xPos) {
        err += ++xPos * 2 + 1;
      }
    } while (xPos <= 0);
  }

  /// this draws a filled circle
  void drawFilledCircle(int x, int y, int radius, bool colored) {
    // Bresenham's algorithm
    int xPos = -radius;
    int yPos = 0;
    int err = 2 - 2 * radius;
    int e2;
    do {
      drawPixel(x - xPos, y + yPos, colored); // are these needed?
      drawPixel(x + xPos, y + yPos, colored); // are these needed?
      drawPixel(x + xPos, y - yPos, colored); // are these needed?
      drawPixel(x - xPos, y - yPos, colored); // are these needed?
      drawHorizontalLine(x + xPos, y + yPos, x - xPos, colored);
      drawHorizontalLine(x + xPos, y - yPos, x - xPos, colored);
      e2 = err;
      if (e2 <= yPos) {
        err += ++yPos * 2 + 1;
        if (-xPos == yPos && e2 <= xPos) {
          e2 = 0;
        }
      }
      if (e2 > xPos) {
        err += ++xPos * 2 + 1;
      }
    } while (xPos <= 0);
  }

  /// this draws another canvas or bitmap into the frame-buffer
  void drawImage(int x, int y, EpdImage image, {bool transparent = false, bool inverted = false}) {
    int offset = 0;
    for (int yd = 0; yd < image.height; yd++) {
      for (int xd = 0; xd < image.width; xd++) {
        if ((image.image[offset] & (0x80 >> (xd % 8))) != 0) {
          drawPixel(x + xd, y + yd, !inverted);
        } else if (!transparent) {
          drawPixel(x + xd, y + yd, inverted);
        }
        if (xd % 8 == 7) {
          offset++;
        }
      }
      if (image.width % 8 != 0) {
        offset++;
      }
    }
  }
}
