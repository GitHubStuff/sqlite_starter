// Flavor_Config allows for configuring properites for different run environments
// (Device, Emulator,Release, and Test).
// Each flavor must have a main() associated.
//  eg  main_device.dart, main_emulator.dart, main_release.dart, main_test.dart
//  where is main() method creates values (called FlavorValues) specific to the
//  flavor, and where the 'launch.json' launches the correct flavor
//
import 'package:flutter/foundation.dart';
import 'package:tracers/tracers.dart' as Log;

// TODO: Modify class to include values needed for given flavor.
class FlavorValues {
//  final String servicesUpdateListUrl;
//  FlavorValues({@required this.servicesUpdateListUrl});
}

enum Flavor {
  DEVICE,
  EMULATOR,
  RELEASE,
  TEST,
}

class FlavorConfig {
  static FlavorConfig _instance;

  final Flavor flavor;
  final FlavorValues values;

  factory FlavorConfig({@required Flavor flavor, @required FlavorValues values}) {
    Log.v('Flavor: ${flavor.toString()}');
    _instance ??= FlavorConfig._internal(flavor, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance => _instance;
  static bool get isDevice => _instance.flavor == Flavor.DEVICE;
  static bool get isEmulator => _instance.flavor == Flavor.EMULATOR;
  static bool get isRelease => _instance.flavor == Flavor.RELEASE;
  static bool get isTest => _instance.flavor == Flavor.TEST;
}
