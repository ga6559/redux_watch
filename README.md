# redux_watch
[Redux Watch](https://github.com/jprichardson/redux-watch) to dart.

Used when you want to be notified that an particular state changed in the redux store.

## Usage
A simple usage example:

```dart
// Create the watch by passing the store and a selector.
var watch =  new  ReduxWatch<AppState, int>(store, (state) => state.todosId);

// Now you can create how many listeners you need.
// Everytime the selector changes by a redux dispatch, the listeners will be called.
watch.listen((int oldValue, int newValue) => print('$oldValue -> $newValue'));
watch.listen((int oldValue, int newValue) => print('Hello World'));
```
