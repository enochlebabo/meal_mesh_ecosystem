import '../views/main_nav_wrapper.dart';
import '../views/restaurant_menu_view.dart';


import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const RESTAURANT_MENU = "/restaurant-menu";


  static final pages = [
    GetPage(name: LOGIN, page: () => const LoginView()), // Replaced the placeholder!
    GetPage(name: HOME, page: () => MainNavWrapper()),
    GetPage(name: RESTAURANT_MENU, page: () => const RestaurantMenuView()),

  ];
}
