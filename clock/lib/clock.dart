import 'dart:io';

import 'package:clock/bmp.dart';
import 'package:clock/rpi/epd.dart';

void main(List<String> args) {
  final black = MonoBitmap.loadAsset('assets/black.bmp');
  final red = MonoBitmap.loadAsset('assets/red.bmp');
  print('finished loading.');
  final display = EPaperDisplay();
  final sig = ProcessSignal.sigint.watch().listen((event) {
    print('Ctrl+C pressed');
    // display.sleep();
    // display.close();
    exit(-1);
  });
  try {
    display.open();
    display.clear();
    display.delayMs(100);
    display.clearBlack();
    display.delayMs(100);
    display.display(black.data, red.data);
    display.delayMs(200);
    display.clear();
  } finally {
    display.sleep();
    display.close();
  }
  print('done main');
  sig.cancel();
}
