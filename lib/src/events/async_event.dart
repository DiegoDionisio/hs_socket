

import 'package:hs_socket/src/events/delegate.dart';

class AsyncEvent {
  final List<AsyncDelegate> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  AsyncDelegate operator +(AsyncDelegate other) {
    _subscribers.add(other);
    return other;
  }

  AsyncDelegate operator - (AsyncDelegate other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return other;
  }

  Future<void> call() async {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          await delegate.call();
        } catch (e) {}
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }
}