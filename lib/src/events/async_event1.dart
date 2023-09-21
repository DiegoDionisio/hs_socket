
import 'package:hs_socket/src/events/delegate.dart';

class AsyncEvent1<T> {
  final List<AsyncDelegate1<T>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  AsyncDelegate1<T> operator +(AsyncDelegate1<T> other) {
    _subscribers.add(other);
    return other;
  }

  AsyncDelegate1<T> operator - (AsyncDelegate1<T> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return other;
  }

  Future<void> call(T arg) async {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          await delegate.call(arg);
        } catch (e) {}
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }
}