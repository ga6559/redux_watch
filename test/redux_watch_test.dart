import 'package:redux/redux.dart';
import 'package:test/test.dart';
import 'package:redux_watch/redux_watch.dart';

void main() {
  group('redux_watch_test', () {
    Store<AppState> store;

    setUp(() {
      store = new Store<AppState>(
        new AppReducer(),
        initialState: new AppState(),
      );
    });

    test('listen fired when values are different', () {
      new ReduxWatch<AppState, int>(store, CounterSelector.counter)
        .listen((int oldValue, int newValue) {
          expect(oldValue, 0);
          expect(newValue, 1);
        });

      store.dispatch(new IncrementCounter());
    });

    test('listen do not fire when values are equals', () {
      new ReduxWatch<AppState, int>(store, CounterSelector.counter)
        .listen((int oldValue, int newValue) {
          throw new AssertionError();
        });

      store.dispatch(new DoNothing());
    });

    group('custom_comparison', () {
      test('listen fired with custom comparator', () {
        int listenCalled = 0;

        new ReduxWatch<AppState, int>(
          store,
          CounterSelector.counter,
          comparator: (int oldValue, int newValue) => newValue > oldValue)
            .listen((int oldValue, int newValue) {
              listenCalled++;

              if (listenCalled == 2) {
                expect(store.state.counter, 1);
              }
            });

        store.dispatch(new DecrementCounter()); // -1 (not called)
        store.dispatch(new IncrementCounter()); // 0 (called)
        store.dispatch(new IncrementCounter()); // 1 (called)
        store.dispatch(new DoNothing()); // (not called)
      });
    });
  });
}

class AppState {
  AppState({
    this.counter = 0,
  });

  final int counter;
}

class AppReducer extends ReducerClass<AppState> {
  final _counter = new CounterReducer();

  @override
  AppState call(AppState state, dynamic action) {
    return new AppState(
      counter: _counter.call(state.counter, action),
    );
  }
}

class CounterReducer extends ReducerClass<int> {
  final _reducers = combineReducers<int>([
    new TypedReducer<int, IncrementCounter>(_increment),
    new TypedReducer<int, DecrementCounter>(_decrement),
  ]);

  @override
  int call(int state, dynamic action) => _reducers(state, action);

  static int _increment(int state, IncrementCounter action) => state + 1;
  static int _decrement(int state, DecrementCounter action) => state - 1;
}

class IncrementCounter {

}

class DecrementCounter {

}

class DoNothing {

}

class CounterSelector {
  static int counter(AppState state) => state.counter;
}
