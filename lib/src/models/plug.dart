import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class Plug {
  FutureOr<Widget> appPlug(Widget child) async => child;
  FutureOr<void> runAppPlug(FutureOr<void> Function() appRunner) async => appRunner();
  Widget materialAppPlug(BuildContext context, Widget child) => child;
  Widget navigatorPlug(BuildContext context, Widget child) => child;
}
