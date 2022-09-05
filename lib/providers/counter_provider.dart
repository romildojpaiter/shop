import 'package:flutter/material.dart';

class CounterState {
  int _value = 1;

  void ind() => _value++;
  void dec() => _value--;

  int get value => _value;

  bool diff(CounterState old) {
    return this._value != old._value;
  }
}

/**
 * Esse provider deve envolver toda a aplicação para estar presente em todos 
 * os pontos dentro do contexto.
 */
class CounterProvider extends InheritedWidget {
  final CounterState counterState = CounterState();

  CounterProvider({required Widget child}) : super(child: child);

  static CounterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>()
        as CounterProvider;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
