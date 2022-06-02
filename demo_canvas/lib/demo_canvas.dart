import 'package:demo/demo.dart';
import 'package:epd/epd.dart';

class CanvasDemo extends DemoRunner {
  CanvasDemo(this.args);

  final List<String> args;

  @override
  Future<void> run() async {
    print('running');
    final display = EpdDisplay(EpdDisplayInterface.epd7in5v3());
    final geekle = EpdBitmap.loadAsset('assets/geekle.bmp');
    display.wake();
    display.clearFrame();
    display.displayFrame();
    if (args.isEmpty) {
      display.displayFrameBuffer(geekle.image);
      display.waitUntilIdle();
    }
    display.sleep();
    display.dispose();
    print('finished');
  }
}







// final display = EpdDisplay(EpdDisplayInterface.epd7in5v3(debug: print, mode: EpdMode.kwrOtp));
// final red = EpdBitmap.loadAsset('assets/red.bmp');
// final black = EpdBitmap.loadAsset('assets/black.bmp');
// display.wake();
// display.displayFrameBuffer(black.image, red.image);
// display.waitUntilIdle();
// display.sleep();
// display.dispose();
