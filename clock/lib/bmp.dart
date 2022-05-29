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
    return MonoBitmap(header, info, data);
  }
}

@Packed(1)
class BitmapFileHeader extends Struct {
  @Uint16()
  external int type;
  @Uint32()
  external int size;
  @Uint32()
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
