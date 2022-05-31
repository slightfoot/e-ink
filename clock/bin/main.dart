import 'dart:io';

import 'package:hotreloader/hotreloader.dart';
import 'dart:async';

import 'package:clock/clock.dart';

Future<void> main(List<String> args) async {
  var clock = Clock();
  HotReloader? reloader;
  try {
    reloader = await HotReloader.create(
      debounceInterval: Duration(seconds: 2),
      onAfterReload: (AfterReloadContext context) {
        if (context.result != HotReloadResult.Succeeded) {
          print('Hot-reload failed: ${context.result}');
        } else {
          clock.stop();
          clock = Clock();
          clock.run();
        }
      },
    );
  } catch (e) {
    print('Hot-reload disabled');
  }
  late StreamSubscription<ProcessSignal> onInterrupt;
  onInterrupt = ProcessSignal.sigint.watch().listen((event) {
    print('Ctrl+C pressed');
    clock.stop();
    onInterrupt.cancel();
    reloader?.stop();
  });
  unawaited(clock.run());
}
