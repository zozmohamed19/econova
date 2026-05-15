import 'package:flutter/material.dart';

import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/map_screen/map_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String mapScreen = '/map-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignUpLoginScreen(),
    signUpLoginScreen: (context) => const SignUpLoginScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    mapScreen: (context) => const MapScreen(),
  };
}
