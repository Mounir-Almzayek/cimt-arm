import 'package:get/get.dart';
import 'package:cimt/presentation/controllers/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController());
  }
}
