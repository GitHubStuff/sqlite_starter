import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../modular/app_module.dart';
import '../flavor_config.dart';

void main() {
  final values = FlavorValues();
  FlavorConfig(flavor: Flavor.DEVICE, values: values);
  runApp(
    ModularApp(module: AppModule()),
  );
}
