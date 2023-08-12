import 'dart:async';

import 'package:flutter/widgets.dart';

Widget _identityWrapper(Widget child) => child;
const defaultPlugWiring = PlugWiring(_identityWrapper);

class PlugWiring {
  final FutureOr<Widget> Function(Widget child) wrapper;

  final Future<dynamic> Function()? init;

  const PlugWiring(
    this.wrapper,
  ) : init = null;

  const PlugWiring.async(
    this.wrapper, {
    required this.init,
  });
}
