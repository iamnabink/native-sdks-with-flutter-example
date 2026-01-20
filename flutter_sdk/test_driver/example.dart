// Copyright 2020 The Flutter team. All rights reserved.


import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_module/main.dart' as app;

// This alternate entrypoint is used for espresso testing. See
// https://pub.dev/packages/espresso for details.
void main() {
  enableFlutterDriverExtension();
  app.main();
}
