import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'counter_service.dart';
import 'method_channel_counter_service.dart';
import 'local_counter_service.dart';

final getIt = GetIt.instance;

/// Initialize services for embedded mode (uses MethodChannel)
void setupEmbeddedServices() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<CounterService>(
    MethodChannelCounterService(),
  );
}

/// Initialize services for standalone mode (uses local state)
void setupStandaloneServices() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<CounterService>(
    LocalCounterService(),
  );
}
