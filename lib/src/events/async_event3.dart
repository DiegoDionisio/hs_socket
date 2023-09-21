import 'package:hs_socket/src/events/delegate.dart';

class AsyncEvent3<T1,T2,T3> {
  final List<Delegate3<T1,T2,T3>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  AsyncEvent3<T1,T2,T3> operator +(Delegate3<T1,T2,T3> other) {
    _subscribers.add(other);
    return this;
  }

  AsyncEvent3<T1,T2,T3> operator - (Delegate3<T1,T2,T3> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return this;
  }

  Future<dynamic> call(T1 arg1, T2 arg2, T3 arg3) async {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          return delegate.call(arg1, arg2, arg3);
        } catch (e) {}
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }
}