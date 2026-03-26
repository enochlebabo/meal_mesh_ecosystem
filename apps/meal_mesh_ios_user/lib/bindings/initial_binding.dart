import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
