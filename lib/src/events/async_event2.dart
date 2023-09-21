
import 'package:hs_socket/src/events/delegate.dart';

class AsyncEvent2<T1,T2> {
  final List<AsyncDelegate2<T1,T2>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  AsyncDelegate2<T1,T2> operator +(AsyncDelegate2<T1,T2> other) {
    _subscribers.add(other);
    return other;
  }

  AsyncDelegate2<T1,T2> operator - (AsyncDelegate2<T1,T2> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return other;
  }

  Future<void> call(T1 arg1, T2 arg2) async {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          await delegate.call(arg1, arg2);
        } catch (e) {}
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }
}