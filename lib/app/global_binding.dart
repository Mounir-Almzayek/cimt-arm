import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';
import 'package:get/get.dart';
import 'global_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GlobalController>(GlobalController(), permanent: true);
    Get.put(ExerciseFlowController(), permanent: true);
  }
}
