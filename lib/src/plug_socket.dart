import 'dart:async';

import 'package:flutter/material.dart' hide runApp;
import 'package:flutter/material.dart' as material show runApp;
import 'package:plugger/src/models/plug.dart';

class PlugSocket {
  static late List<Plug> _plugs;
  static bool _runAppCalled = false;

  static FutureOr<void> runApp({
    required FutureOr<Widget> Function() appBuilder,
    List<Plug> plugs = const [],
  }) async {
    _plugs = plugs.reversed.toList();
    _runAppCalled = true;

    identityRunner() async => material.runApp(await _plugs.toList().plugApp(appBuilder()));
    _plugs.plugAppRunner(identityRunner)();
  }

  static Widget materialApp(BuildContext context, MaterialApp child) {
    assert(_runAppCalled);

    return _plugs.plugMaterialApp(context, child);
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
    return fold(child, (previous, plug) async {
      return plug.appPlug(await previous);
    });
  }

  Widget plugMaterialApp(BuildContext context, MaterialApp child) {
    return fold(child, (previous, plug) {
      return Builder(
        builder: (context) => plug.materialAppPlug(context, previous),
      );
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
