

import 'package:flutter/material.dart';

import '../../Views/Login.dart';
import '../../Views/Signup.dart';
import 'RouteName.dart';

class RoutesNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (context) => Login());
      case RouteName.signUp:
        return MaterialPageRoute(builder: (_) =>  Signup());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No Route found with this name'),
            ),
          );
        });
    }
  }
}
