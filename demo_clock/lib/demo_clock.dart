import 'dart:math' as math;

import 'package:demo/demo.dart';
import 'package:epd/epd.dart';
import 'package:intl/intl.dart';

int _radialPositionX(int offset, double radius, double degrees) {
  final radians = (degrees / 180) * math.pi;
  return (offset + radius * math.sin(radians)).round();
}

int _radialPositionY(int offset, double radius, double degrees) {
  final radians = (degrees / 180) * math.pi;
  return (offset + radius * -math.cos(radians)).round();
}

class ClockDemo extends DemoRunner {
  ClockDemo() {
    _display = EpdDisplay(EpdDisplayInterface.epd7in5v3());
    _digital = DigitalDisplay(_display);
    _analog = AnalogDisplay(_display, 90);
  }

  late EpdDisplay _display;
  late DigitalDisplay _digital;
  late AnalogDisplay _analog;

  @override
  Future<void> run() async {
    print('running...');
    try {
      _display.wake();
      _display.clearFrame();

      _analog.renderClockFace();

      final stopWatch = Stopwatch();
      for (int tick = 0; !stopped; tick++) {
        // print('tick $tick');
        stopWatch.start();
        final time = DateTime.now();
        _analog.renderClockHands(time);
        _digital.render(64, _display.interface.cy - 48, time);
        stopWatch.stop();
        if (stopWatch.elapsedMilliseconds < 1000) {
          await Future.delayed(Duration(milliseconds: 1000 - stopWatch.elapsedMilliseconds));
        }
        stopWatch.reset();
      }
    } finally {
      _display.sleep();
      _display.dispose();
    }
    print('finished');
  }

  @override
  void stop() {
    _display.sleep();
    _display.dispose();
    super.stop();
  }
}

class AnalogDisplay {
  AnalogDisplay(this._display, this._radius) {
    clockFace = EpdCanvas(336, 336, inverted: true);
  }

  final EpdDisplay _display;
  final int _radius;
  late final EpdCanvas clockFace;

  int get px => (_display.interface.cx + (_display.interface.cx ~/ 2) - clockFace.cx) & ~0x03;

  int get py => _display.interface.cy - clockFace.cy;

  void renderClockFace() {
    final cx = clockFace.cx;
    final cy = clockFace.cy;

    clockFace.clear();

    clockFace.drawFilledCircle(cx, cy, 168, true);
    clockFace.drawFilledCircle(cx, cy, 158, false);

    final circumference = 360.0;
    final hourStep = circumference / 12;
    int hour = 12;
    for (double angle = 0; angle < circumference; angle += hourStep) {
      final x = _radialPositionX(cx, 132, angle);
      final y = _radialPositionY(cy, 132, angle);
      final value = '$hour';
      final width = clockFace.measureText(value, font24);
      clockFace.drawText(x - (width ~/ 2), y - (font24.height ~/ 2), value, font24, true);
      hour = (hour % 12) + 1;
    }

    final minuteStep = circumference / 60;
    int minute = 0;
    for (double angle = 0; angle < circumference; angle += minuteStep) {
      if ((minute % 5) == 0) {
        final x = _radialPositionX(cx, 105, angle);
        final y = _radialPositionY(cy, 105, angle);
        clockFace.drawFilledCircle(x, y, 3, true);
      } else {
        final x0 = _radialPositionX(cx, 100, angle);
        final y0 = _radialPositionY(cy, 100, angle);
        final x1 = _radialPositionX(cx, 110, angle);
        final y1 = _radialPositionY(cy, 110, angle);
        clockFace.drawLine(x0, y0, x1, y1, true);
      }
      minute++;
    }

    _display.setPartialWindow(
        clockFace.image, px, py, clockFace.width, clockFace.height, EpdPartialMode.buffer2);
    _display.displayFrame();
    _display.waitUntilIdle();
  }

  void renderClockHands(DateTime time) {
    final cx = clockFace.cx;
    final cy = clockFace.cy;

    clockFace.drawFilledCircle(cx, cy, _radius, false);

    final hour = 360 * ((((time.hour % 12) * 60 * 60) + (time.minute * 60)) / (12 * 60 * 60));
    _drawLine(clockFace, cx, cy, _radius * 0.66, hour);

    final minute = 360 * ((time.minute * 60) / (60 * 60));
    _drawLine(clockFace, cx, cy, _radius.toDouble(), minute);

    _display.setPartialWindow(
        clockFace.image, px, py, clockFace.width, clockFace.height, EpdPartialMode.buffer2);
    _display.displayFrameQuick();
    _display.waitUntilIdle();
  }

  void _drawLine(EpdCanvas canvas, int x, int y, double radius, double angle) {
    for (double a = angle - 2; a < angle + 2; a += 0.25) {
      final x1 = _radialPositionX(x, radius, a);
      final y1 = _radialPositionY(y, radius, a);
      canvas.drawLine(x, y, x1, y1, true);
    }
  }
}

class DigitalDisplay {
  DigitalDisplay(this._display) {
    _digits = <EpdBitmap>[
      for (int i = 0; i < 10; i++) //
        EpdBitmap.loadAsset('assets/digit_$i.bmp'),
    ];
    _colon = EpdBitmap.loadAsset('assets/digit_colon.bmp');

    // HH:MM:SS = 8 digits, 4 spacing
    final width = _digits[0].width * 6 + _colon.width * 2;
    final height = _digits[0].height + 4 + 20;
    _canvas = EpdCanvas(width, height, inverted: true);
  }

  final EpdDisplay _display;
  late final List<EpdBitmap> _digits;
  late final EpdBitmap _colon;
  late final EpdCanvas _canvas;
  final _format = DateFormat('EEEEE dd MMMM yyyy');

  void render(int x, int y, DateTime time) {
    final digits = <int>[
      time.hour ~/ 10,
      time.hour % 10,
      -1,
      time.minute ~/ 10,
      time.minute % 10,
      -1,
      time.second ~/ 10,
      time.second % 10,
    ];
    _canvas.clear();
    for (int i = 0, dx = 0; i < digits.length; i++) {
      final index = digits[i];
      final digit = (index == -1) ? _colon : _digits[index];
      _canvas.drawImage(dx, 0, digit, inverted: true);
      dx += digit.width;
    }

    final date = _format.format(time);
    final dx = _canvas.cx - (_canvas.measureText(date, font20) ~/ 2);
    _canvas.drawText(dx, 68, _format.format(time), font20, true);

    for (int i = 0; i < 3; i++) {
      _display.setPartialWindow(
          _canvas.image, x, y, _canvas.width, _canvas.height, EpdPartialMode.buffer2);
      _display.displayFrameQuick();
      _display.waitUntilIdle();
    }
  }
}
