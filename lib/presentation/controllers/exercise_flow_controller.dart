import 'package:get/get.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/models/exercise.dart';
import 'package:cimt/data/repository/user_repository.dart';

class ExerciseFlowController extends GetxController {
  final global = Get.find<GlobalController>();

  RxInt currentExerciseIndex = 0.obs;
  RxBool isRest = false.obs;
  RxBool isVideoExercise = false.obs;
  List<Exercise> get exercises => global.part?.exercises ?? [];

  Exercise? get currentExercise {
    if (exercises.isEmpty || currentExerciseIndex.value >= exercises.length) {
      return null;
    }
    return exercises[currentExerciseIndex.value];
  }

  int get totalExercises => exercises.length;

  @override
  void onInit() {
    super.onInit();
    currentExerciseIndex.value = 0;
    isRest.value = false;
    isVideoExercise.value = false;
    isVideoExercise.refresh();
    isRest.refresh();
    currentExerciseIndex.refresh();
  }

  void setVideoExercise(bool isVideo) {
    isVideoExercise.value = isVideo;
    isVideoExercise.refresh();
  }

  void nextExercise() {
    if (currentExerciseIndex.value < exercises.length - 1) {
      currentExerciseIndex.value++;
      isRest.value = false;
      isVideoExercise.value = false;
      isVideoExercise.refresh();
      isRest.refresh();
      currentExerciseIndex.refresh();
    }
  }

  void previousExercise() {
    if (currentExerciseIndex.value > 0) {
      currentExerciseIndex.value--;
      isRest.value = false;
      isVideoExercise.value = false;
      isVideoExercise.refresh();
      isRest.refresh();
      currentExerciseIndex.refresh();
    }
  }

  void startRest() {
    isRest.value = true;
    isRest.refresh();
  }

  void endRest() {
    isRest.value = false;
    nextExercise();
    isRest.refresh();
  }

  Future<void> markExerciseCompleted() async {
    final user = global.user;
    final section = global.section;
    final stage = global.stage;
    final part = global.part;
    final exercise = currentExercise;
    if (user != null &&
        section != null &&
        stage != null &&
        part != null &&
        exercise != null) {
      await UserRepository.recordExerciseCompletionById(
        user.id,
        section.id,
        stage.id,
        exercise.id,
      );
      isVideoExercise.refresh();
      isRest.refresh();
      currentExerciseIndex.refresh();
    }
  }

  bool get isLastExercise => currentExerciseIndex.value == exercises.length - 1;
  bool get isFirstExercise => currentExerciseIndex.value == 0;
}
