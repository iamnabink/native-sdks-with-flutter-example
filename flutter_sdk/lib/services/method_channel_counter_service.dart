import 'dart:async';
import 'package:flutter/services.dart';
import 'counter_service.dart';

/// Counter service implementation using MethodChannel for embedded mode
class MethodChannelCounterService extends CounterService {
  MethodChannelCounterService() {
    try {
      _channel.setMethodCallHandler(_handleMessage);
      _channel.invokeMethod<void>('requestCounter');
    } catch (e) {
      print('Error initializing MethodChannel: $e');
    }
  }

  final _channel = const MethodChannel('dev.flutter.example/counter');
  final _counterController = StreamController<int>.broadcast();
  
  int _count = 0;

  @override
  int get count => _count;

  @override
  void increment() {
    _channel.invokeMethod<void>('incrementCounter');
  }

  @override
  void requestCounter() {
    _channel.invokeMethod<void>('requestCounter');
  }

  @override
  Stream<int> get counterStream => _counterController.stream;

  Future<dynamic> _handleMessage(MethodCall call) async {
    if (call.method == 'reportCounter') {
      _count = call.arguments as int;
      _counterController.add(_count);
    }
  }

  void dispose() {
    _counterController.close();
  }
}
