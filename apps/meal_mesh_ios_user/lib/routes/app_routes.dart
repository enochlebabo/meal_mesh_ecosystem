import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';

  static final pages = [
    GetPage(name: LOGIN, page: () => const LoginView()), // Replaced the placeholder!
    GetPage(name: HOME, page: () => const HomeView()),
  ];
}
