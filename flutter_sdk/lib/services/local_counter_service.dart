import 'dart:async';
import 'counter_service.dart';

/// Counter service implementation using local state for standalone mode
class LocalCounterService extends CounterService {
  LocalCounterService() {
    // Initialize with 0
    _counterController.add(_count);
  }

  final _counterController = StreamController<int>.broadcast();
  
  int _count = 0;

  @override
  int get count => _count;

  @override
  void increment() {
    _count++;
    _counterController.add(_count);
  }

  @override
  void requestCounter() {
    // In local mode, just send current count
    _counterController.add(_count);
  }

  @override
  Stream<int> get counterStream => _counterController.stream;

  void dispose() {
    _counterController.close();
  }
}
