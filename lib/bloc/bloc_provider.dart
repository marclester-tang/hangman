import 'package:flutter/material.dart';
import 'package:hangman/bloc/bloc_base.dart';

class BlocProvider<T extends BlocBase> extends InheritedWidget {
  final T bloc;
  final Function(T, BlocProvider<T>) _updateShouldNotify;

  BlocProvider({
    @required T bloc,
    Key key,
    Function(T, BlocProvider<T>) updateShouldNotify,
    @required Widget child,
  })  : bloc = bloc,
        _updateShouldNotify = updateShouldNotify,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(BlocProvider<T> oldWidget) =>
      _updateShouldNotify != null
          ? _updateShouldNotify(bloc, oldWidget)
          : false;

  static T of<T extends BlocBase>(BuildContext context) {
    final Type type = _typeOf<BlocProvider<T>>();
    return (context.inheritFromWidgetOfExactType(type) as BlocProvider).bloc;
  }

  static Type _typeOf<T>() => T;
}
