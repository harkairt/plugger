import 'dart:async';

import 'package:flutter/material.dart' hide runApp;
import 'package:flutter/material.dart' as material show runApp;
import 'package:plugger/src/plug.dart';

class Plugger {
  static late List<Plug> _plugs;
  static bool _runAppCalled = false;

  static FutureOr<void> runApp(
    Widget app, {
    List<Plug> plugs = const [],
  }) async {
    _plugs = plugs.reversed.toList();
    _runAppCalled = true;

    final pluggedApp = await _plugs.toList().plugApp(app);
    identityRunner() async => material.runApp(pluggedApp);
    _plugs.plugAppRunner(identityRunner)();
  }

  static Widget navigator(BuildContext context, Widget child) {
    assert(_runAppCalled);

    return _plugs.plugNavigator(context, child);
  }

  static Widget page(BuildContext context, Widget child) {
    assert(_runAppCalled);

    return _plugs.plugPage(context, child);
  }
}

extension on List<Plug> {
  FutureOr<void> Function() plugAppRunner(FutureOr<void> Function() appRunner) {
    return fold(appRunner, (previous, plug) {
      return () => plug.runAppPlug(() => previous());
    });
  }

  FutureOr<Widget> plugApp(FutureOr<Widget> child) async {
    final plugWiring = map((plug) => plug.appPlug());

    final initFutures = plugWiring.map((p) => p.init?.call()).whereType<Future<dynamic>>();
    await Future.wait(initFutures);

    return plugWiring.fold(child, (previous, wiring) async {
      return wiring.wrapper(await previous);
    });
  }

  Widget plugNavigator(BuildContext context, Widget child) {
    return fold(child, (previous, plug) {
      return Builder(
        builder: (context) => plug.navigatorPlug(context, previous),
      );
    });
  }

  Widget plugPage(BuildContext context, Widget child) {
    return fold(child, (previous, plug) {
      return Builder(
        builder: (context) => plug.pagePlug(context, previous),
      );
    });
  }
}
