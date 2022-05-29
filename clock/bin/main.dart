// import 'package:hotreloader/hotreloader.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:clock/clock.dart' as clock;
import 'package:bcm2835/bcm2835.dart';

Future<void> main(List<String> args) async {
  // try {
  //   final reloader = await HotReloader.create(
  //     debounceInterval: Duration(seconds: 2),
  //     onAfterReload: (AfterReloadContext context) {
  //       if (context.result != HotReloadResult.Succeeded) {
  //         print('Hot-reload failed: ${context.result}');
  //       }
  //       clock.main(args);
  //     },
  //   );
  // } catch (e) {
  //   print('Hot-reload disabled');
  // }

  clock.main(args);

  //final bcm2835 = Bcm2835(DynamicLibrary.open('/usr/local/lib/libbcm2835.so'));
  //try {
  //  bcm2835.set_debug(0);
  //  if (bcm2835.init() == 0) {
  //    print('bcm2835 init failed  !!!');
  //    return;
  //  } else {
  //    print('bcm2835 init success !!! ${bcm2835.version()}');
  //  }
  //  bcm2835.gpio_fsel(26, FunctionSelect.GPIO_FSEL_OUTP);
  //  for (int i = 0; i < 10; i++) {
  //    if (i % 2 == 0) {
  //      print('blink $i off');
  //      bcm2835.gpio_write(26, 0); // Sets the specified pin output to LOW.
  //    } else {
  //      print('blink $i on');
  //      bcm2835.gpio_write(26, 1); // Sets the output to HIGH
  //    }
  //    bcm2835.delay(250);
  //  }
  //  bcm2835.gpio_fsel(26, FunctionSelect.GPIO_FSEL_INPT);
  //  print('done');
//
  //  // bcm2835.gpio_write(26, 0); // 0 = LOW , 1 = HIGH
//
  //} finally {
  //  bcm2835.close();
  //}

  //try {
  //print('started');
  //bcm2835.gpio_fsel(26, FunctionSelect.GPIO_FSEL_OUTP);
  //while (true) {
  //  bcm2835.gpio_clr(26); // Sets the specified pin output to LOW.
  //  bcm2835.delay(1000 ~/ 260 ~/ 2);
  //  bcm2835.gpio_set(26); // Sets the output to HIGH
  //  bcm2835.delay(1000 ~/ 260 ~/ 2);
  //}
  // bcm2835.gpio_fsel(26, FunctionSelect.GPIO_FSEL_INPT);
  // print('done');

  // bcm2835.gpio_write(26, 0); // 0 = LOW , 1 = HIGH

  //} finally {
  // bcm2835.close();
  //}

  // cleanup
  // reloader.stop();
}
