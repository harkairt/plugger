import 'dart:async';

import 'package:flutter/widgets.dart';

Widget _identityWrapper(Widget child) => child;
const defaultPlugWiring = PlugWiring(_identityWrapper, init: null);

class PlugWiring {
  final FutureOr<Widget> Function(Widget child) wrapper;

  final Future<dynamic> Function()? init;

  const PlugWiring(
    this.wrapper, {
    this.init,
  });
}
