import 'package:hs_socket/src/events/delegate.dart';

class Event3<T1, T2, T3> {
  final List<Delegate3<T1, T2, T3>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  Event3<T1, T2, T3> operator + (Delegate3<T1, T2, T3> other) {
    _subscribers.add(other);
    return this;
  }

  Event3<T1, T2, T3> operator - (Delegate2<T1, T2> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }    
    return this;
  }

  void call(T1 arg1, T2 arg2, T3 arg3) {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        delegate.call(arg1, arg2, arg3); 
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }

}