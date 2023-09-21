import 'package:hs_socket/src/events/delegate.dart';

class Event1<T> {
  final List<Delegate1<T>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  Event1<T> operator + (Delegate1<T> other) {
    _subscribers.add(other);
    return this;
  }

  Event1<T> operator - (Delegate1<T> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }    
    return this;
  }

  void call(T arg) {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          delegate.call(arg);
        } catch (e) {} 
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }

}