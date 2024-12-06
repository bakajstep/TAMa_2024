import 'package:flutter/material.dart';

class RouteObserverProvider extends InheritedWidget {
  final RouteObserver<MaterialPageRoute> routeObserver;

  const RouteObserverProvider({
    super.key,
    required this.routeObserver,
    required super.child,
  });

  static RouteObserverProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteObserverProvider>()!;
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) {
    return routeObserver != oldWidget.routeObserver;
  }
}
