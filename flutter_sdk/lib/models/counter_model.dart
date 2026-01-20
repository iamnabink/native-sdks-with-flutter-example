import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/service_locator.dart';
import '../services/counter_service.dart';

/// A simple model that uses a [CounterService] as the source of truth for the
/// state of a counter.
///
/// In embedded mode, it uses MethodChannel to communicate with native code.
/// In standalone mode, it uses local state management.
class CounterModel extends ChangeNotifier {
  CounterModel() {
    _service = getIt<CounterService>();
    _count = _service.count;
    
    // Listen to counter stream updates
    _subscription = _service.counterStream.listen((count) {
      _count = count;
      notifyListeners();
    });
    
    // Request initial counter value
    _service.requestCounter();
  }

  late final CounterService _service;
  late final StreamSubscription<int> _subscription;
  int _count = 0;

  int get count => _count;

  void increment() {
    _service.increment();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
