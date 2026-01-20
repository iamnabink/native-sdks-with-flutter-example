// Nabraj Khadka 2026 


import 'package:flutter/material.dart';
import 'package:flutter_module/application.dart';
import 'package:provider/provider.dart';
import 'services/service_locator.dart';
import 'models/counter_model.dart';

/// The entrypoint for the flutter module (standalone mode).
/// Uses local state management without MethodChannel.
void main() {
  // This call ensures the Flutter binding has been set up
  WidgetsFlutterBinding.ensureInitialized();

  // Setup services for standalone mode (uses local state)
  setupStandaloneServices();

  final model = CounterModel();

  runApp(ChangeNotifierProvider.value(value: model, child: const MyApp()));
}
