import 'package:get/get.dart';
import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';

class ExerciseFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExerciseFlowController>(ExerciseFlowController(), permanent: true);
  }
}
