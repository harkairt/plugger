import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:plugger/src/plug_wiring.dart';

abstract class Plug {
  FutureOr<void> runAppPlug(FutureOr<void> Function() appRunner) async => appRunner();
  PlugWiring appPlug() => defaultPlugWiring;
  Widget materialAppPlug(BuildContext context, Widget child) => child;
  Widget navigatorPlug(BuildContext context, Widget child) => child;
  Widget pagePlug(BuildContext context, Widget child) => child;
}
