import 'package:hs_socket/src/events/delegate.dart';

class Event {
  final List<Delegate> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  Event operator +(Delegate other) {
    _subscribers.add(other);
    return this;
  }

  Event operator - (Delegate other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return this;
  }

  void call() {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          delegate.call();
        } catch (e) {}
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }
  
}