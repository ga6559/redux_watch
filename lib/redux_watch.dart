import 'package:redux/redux.dart';

class ReduxWatch<T, U> {
  ReduxWatch(this.store, this.selector, {this.comparator}) {
    _oldValue = selector(store.state);
    comparator ??= (U oldValue, U newValue) => oldValue != newValue;
    store.onChange.listen(_onChange);
  }

  final Store<T> store;
  final Function(T) selector;
  Function(U, U) comparator;
  U _oldValue;
  var _callbacks = new List<Function(U oldValue, U newValue)>();

  void listen(Function(U oldValue, U newValue) callback) {
    _callbacks.add(callback);
  }

  void _onChange(T state) {
    var newValue = selector(state);

    if (comparator(_oldValue, newValue)) {
      _callbacks.forEach((callback) => callback(_oldValue, newValue));
    }

    _oldValue = newValue;
  }
}
