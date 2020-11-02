import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../modular/app_module.dart';
import '../flavor_config.dart';

const _databaseName = 'fhcp.db';
const _exposeSql = false;
void main() {
  final values = FlavorValues(
    sqliteDatabaseName: _databaseName,
    sqliteDevelopment: _exposeSql,
  );
  FlavorConfig(flavor: Flavor.RELEASE, values: values);
  runApp(
    ModularApp(module: AppModule()),
  );
}
