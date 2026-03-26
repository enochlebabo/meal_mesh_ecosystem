import 'package:get/get.dart';
import '../views/home/home_view.dart';
import '../views/restaurant_menu_view.dart';
import '../views/auth/login_view.dart';
import '../views/main_nav_wrapper.dart'; // THE MISSING IMPORT
import '../controllers/cart_controller.dart';
import '../controllers/restaurant_controller.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const RESTAURANT_MENU = '/restaurant-menu';

  static final pages = [
    GetPage(name: LOGIN, page: () => const LoginView()),
    GetPage(name: HOME, page: () => const MainNavWrapper()),
    GetPage(
      name: RESTAURANT_MENU, 
      page: () => RestaurantMenuView(
        restaurantId: Get.arguments?['id'] ?? '',
        restaurantName: Get.arguments?['name'] ?? 'Menu',
        restaurantImage: Get.arguments?['image'] ?? '',
      ),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CartController());
        Get.lazyPut(() => RestaurantController());
      }),
    ),
  ];
}
