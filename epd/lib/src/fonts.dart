export 'fonts/font16.dart';
export 'fonts/font20.dart';
export 'fonts/font24.dart';

class EpdFont {
  const EpdFont({
    required this.name,
    required this.size,
    required this.width,
    required this.height,
    required this.data,
  });

  final String name;
  final int size;
  final int width;
  final int height;
  final List<int> data;

  int get cx => (width ~/ 2);

  int get cy => (height ~/ 2);

  @override
  String toString() => '${name}_$size(${width}x$height)';
}
