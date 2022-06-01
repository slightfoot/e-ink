import 'dart:io';

import 'package:hotreloader/hotreloader.dart';
import 'dart:async';

import 'package:meta/meta.dart';

/// Implement this class to run a demo
abstract class DemoRunner {
  DemoRunner();

  bool _stopped = false;

  /// [run] should monitor this boolean on a regular
  /// basis to determine if its been stopped.
  bool get stopped => _stopped;

  /// Demo runner. This should continue executing until flagged to stop.
  Future<void> run();

  /// Stop on-going demo
  @mustCallSuper
  void stop() {
    _stopped = true;
  }
}

typedef DemoCreator = DemoRunner Function();

Future<void> runDemo(DemoCreator creator) async {
  late StreamSubscription<ProcessSignal>? onInterrupt;

  var demo = creator();

  HotReloader? reloader;
  try {
    reloader = await HotReloader.create(
      debounceInterval: Duration(seconds: 2),
      onAfterReload: (AfterReloadContext context) {
        if (context.result != HotReloadResult.Succeeded) {
          print('Hot-reload failed: ${context.result}');
        } else {
          demo.stop();
          demo = creator();
          demo.run();
        }
      },
    );
  } catch (e) {
    print('Hot-reload disabled');
  }

  void cleanup() {
    onInterrupt?.cancel();
    onInterrupt = null;
    reloader?.stop();
  }

  onInterrupt = ProcessSignal.sigint.watch().listen((event) {
    print('Ctrl+C pressed');
    demo.stop();
    cleanup();
  });

  unawaited(demo.run());
  cleanup();
}
