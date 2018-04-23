import 'package:redux/redux.dart';

class ReduxWatch<T, U> {
  ReduxWatch(this.store, this.selector) {
    _oldValue = selector(store.state);
    store.onChange.listen(_onChange);
  }

  final Store<T> store;
  final Function(T) selector;
  var _callbacks = new List<Function(U oldValue, U newValue)>();
  U _oldValue;

  void listen(Function(U oldValue, U newValue) callback) {
    _callbacks.add(callback);
  }

  void _onChange(T state) {
    U newValue = selector(state);

    if (_oldValue != newValue) {
      _callbacks.forEach((callback) => callback(_oldValue, newValue));
    }

    _oldValue = newValue;
  }
}
