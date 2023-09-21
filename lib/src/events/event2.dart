import 'package:hs_socket/src/events/delegate.dart';

class Event2<T1, T2> {
  final List<Delegate2<T1, T2>> _subscribers = [];
  bool get hasListeners => _subscribers.isNotEmpty;
  
  Event2<T1, T2> operator + (Delegate2<T1, T2> other) {
    _subscribers.add(other);
    return this;
  }

  Event2<T1, T2> operator - (Delegate2<T1, T2> other) {
    if(_subscribers.contains(other)) {
      _subscribers.remove(other);
    }
    return this;
  }

  Future<void> call(T1 arg1, T2 arg2) async {
    if(_subscribers.isNotEmpty) {
      for (var delegate in _subscribers) { 
        try {
          delegate.call(arg1, arg2);
        } catch (e) {} 
      }
    }
  }

  void clear() {
    _subscribers.clear();
  }

}