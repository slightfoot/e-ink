import 'dart:io';

import 'package:clock/bmp.dart';
import 'package:clock/rpi/epd.dart';

void main(List<String> args) {
  final black = MonoBitmap.loadAsset('assets/black.bmp');
  final red = MonoBitmap.loadAsset('assets/red.bmp');
  print('finished loading.');
  final display = EPaperDisplay();
  ProcessSignal.sigint.watch().listen((event) {
    print('Ctrl+C pressed');
    display.sleep();
    display.close();
  });
  try {
    display.init();
    display.clear();
    display.delayMs(500);
    display.clearBlack();
    display.delayMs(500);
    display.display(black.data, red.data);
    display.delayMs(1000);
    //display.clear();
  } finally {
    //display.sleep();
    display.close();
  }

  print('done');
}
