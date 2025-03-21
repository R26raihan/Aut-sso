import '../screens//splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main/main_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';

  static final routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    main: (context) => const MainPage(),
  };
}
