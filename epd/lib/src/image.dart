import 'package:epd/epd.dart';

/// Interface to represent image data/
/// See [EpdCanvas] and [EpdBitmap]
abstract class EpdImage {
  int get width;

  int get height;

  List<int> get image;

  /// Returns the center X coordinate.
  int get cx => width ~/ 2;

  /// Returns the center Y coordinate.
  int get cy => height ~/ 2;
}
