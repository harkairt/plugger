import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class Plug {
  FutureOr<void> runAppPlug(FutureOr<void> Function() appRunner) async => appRunner();
  FutureOr<Widget> appPlug(Widget child) async => child;
  Widget materialAppPlug(BuildContext context, Widget child) => child;
  Widget navigatorPlug(BuildContext context, Widget child) => child;
  Widget pagePlug(BuildContext context, Widget child) => child;
}
