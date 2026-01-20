/// Interface for counter service operations
abstract class CounterService {
  int get count;
  
  void increment();
  
  void requestCounter();
  
  Stream<int> get counterStream;
}
