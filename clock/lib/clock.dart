import 'package:clock/bmp.dart';
import 'package:epd/epd.dart';

class Clock {
  Clock() {
    display = EPaperDisplay(EPaperDisplayInterface.epd7in5v3());
    image1 = MonoBitmap.loadAsset('assets/black.bmp');
    image2 = MonoBitmap.loadAsset('assets/red.bmp');
  }

  late EPaperDisplay display;
  late MonoBitmap image1;
  late MonoBitmap image2;

  bool _stopped = false;

  Future<void> run() async {
    print('running...');
    try {
      display.wake();
      display.clearFrame();
      display.displayFrame();
      display.delayMs(20);
      display.displayFrameBuffer(image2.data);
      display.delayMs(20);

      int tick = 0;
      while (!_stopped) {
        print('tick $tick');
        tick++;
        await Future.delayed(const Duration(seconds: 1));
      }
    } finally {
      display.sleep();
      display.dispose();
    }
    print('finished');
  }

  void stop() {
    display.sleep();
    display.dispose();
    _stopped = true;
  }
}
