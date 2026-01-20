// Nabraj Khadka 2026 

import 'package:flutter/material.dart';
import 'package:flutter_module/application.dart';
import 'package:provider/provider.dart';
import 'services/service_locator.dart';
import 'models/counter_model.dart';

/// The entrypoint for the flutter module (embedded mode).
/// Uses MethodChannel to communicate with native iOS/Android.
void main() {
  // This call ensures the Flutter binding has been set up before creating the
  // MethodChannel-based model.
  WidgetsFlutterBinding.ensureInitialized();

  // Setup services for embedded mode (uses MethodChannel)
  setupEmbeddedServices();

  final model = CounterModel();

  runApp(ChangeNotifierProvider.value(value: model, child: const MyApp()));
}
