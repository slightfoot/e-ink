import 'package:demo/demo.dart';
import 'package:epd/epd.dart';

class CanvasDemo extends DemoRunner {
  CanvasDemo(this.args) {
    _display = EpdDisplay(EpdDisplayInterface.epd7in5v3());
    _bitmap = EpdBitmap.loadAsset('assets/geekle.bmp');
  }

  final List<String> args;
  late EpdDisplay _display;
  late EpdBitmap _bitmap;

  @override
  Future<void> run() async {
    _display.wake();
    _display.clearFrame();
    _display.displayFrame();
    if (args.isEmpty) {
      _display.displayFrameBuffer(_bitmap.image);
      _display.waitUntilIdle();
    }
    _display.sleep();
    _display.dispose();
  }
}
