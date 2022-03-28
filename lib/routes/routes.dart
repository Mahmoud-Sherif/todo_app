import 'package:flutter/material.dart';
import 'package:todo_app/pages/login.dart';
import 'package:todo_app/pages/register.dart';
import 'package:todo_app/pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = 'registerPage';
  static const String todoPage = 'todoPAge';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );
      case todoPage:
        return MaterialPageRoute(
          builder: (context) => TodoPage(),
        );
      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
