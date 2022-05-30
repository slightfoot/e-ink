import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _BI_MONOCHROME = 1;

class MonoBitmap {
  MonoBitmap(this.header, this.info, this.data);

  final BitmapFileHeader header;
  final BitmapInfoHeader info;
  final Uint8List data;

  static MonoBitmap loadAsset(String asset) {
    return loadFile(File(asset));
  }

  static MonoBitmap loadFile(File file) {
    return loadData(file.readAsBytesSync());
  }

  static MonoBitmap loadData(Uint8List file) {
    final ptr = malloc<Uint8>(file.length);
    ptr.asTypedList(file.length).setAll(0, file);
    final header = ptr.cast<BitmapFileHeader>().ref;
    if (header.type != 0x4D42 && header.size == file.length && header.offset < file.length) {
      throw Exception('File not a bitmap');
    }
    final info = ptr.elementAt(sizeOf<BitmapFileHeader>()).cast<BitmapInfoHeader>().ref;
    if (info.bitCount != _BI_MONOCHROME) {
      throw Exception('Bitmap is not monochrome: ${info.bitCount}');
    }
    if (header.offset + info.sizeImage > file.length) {
      throw Exception('Bitmap image corrupt: ${header.offset + info.sizeImage} > ${file.length}');
    }
    final data = ptr.elementAt(header.offset).asTypedList(info.sizeImage);

    // Bitmap files are stored bottom-to-top (as such the last row of the image is at the top)
    // We need to flip the rows around in the raw data as we use it top-to-bottom.
    final flipped = Uint8List(info.sizeImage);
    final strideInBytes = info.width ~/ 8; // 1bit per pixel
    for (int y = 0; y < info.height; y++) {
      final from = (info.height - y - 1) * strideInBytes;
      final to = y * strideInBytes;
      flipped.setRange(to, to + strideInBytes, data.getRange(from, from + strideInBytes));
    }

    return MonoBitmap(header, info, flipped);
  }
}

@Packed(1)
class BitmapFileHeader extends Struct {
  @Uint16()
  external int type;
  @Uint32()
  external int size;
  @Uint32()
  // ignore: unused_field
  external int _reserved;
  @Uint32()
  external int offset;
}

@Packed(1)
class BitmapInfoHeader extends Struct {
  @Uint32()
  external int size;
  @Uint32()
  external int width;
  @Uint32()
  external int height;
  @Uint16()
  external int planes;
  @Uint16()
  external int bitCount;
  @Uint32()
  external int compression;
  @Uint32()
  external int sizeImage;
  @Int32()
  external int xPixelsPerMeter;
  @Int32()
  external int yPixelsPerMeter;
  @Uint32()
  external int colorsUsed;
  @Uint32()
  external int colorsImportant;
}
