import 'package:cimt/data/models/session.dart';
import 'package:get/get.dart';
import 'package:cimt/data/models/user.dart';
import 'package:cimt/data/models/workout_section.dart';
import 'package:cimt/data/models/stage.dart';
import 'package:cimt/data/models/part.dart';

class GlobalController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<WorkoutSection?> selectedSection = Rx<WorkoutSection?>(null);
  final Rx<Stage?> selectedStage = Rx<Stage?>(null);
  final Rx<Session?> selectedSession = Rx<Session?>(null);
  final Rx<Part?> selectedPart = Rx<Part?>(null);
  final RxBool isFromFreeTraining = true.obs;

  // Getters for convenience
  User? get user => currentUser.value;
  WorkoutSection? get section => selectedSection.value;
  Stage? get stage => selectedStage.value;
  Session? get session => selectedSession.value;
  Part? get part => selectedPart.value;
  bool get isFreeTraining => isFromFreeTraining.value;

  // Setters for convenience
  set user(User? value) {
    currentUser.value = value;
    currentUser.refresh();
  }

  set section(WorkoutSection? value) {
    selectedSection.value = value;
    selectedSection.refresh();
  }

  set stage(Stage? value) {
    selectedStage.value = value;
    selectedStage.refresh();
  }

  set session(Session? value) {
    selectedSession.value = value;
    selectedSession.refresh();
  }

  set part(Part? value) {
    selectedPart.value = value;
    selectedPart.refresh();
  }

  set isFreeTraining(bool value) {
    isFromFreeTraining.value = value;
    isFromFreeTraining.refresh();
  }
}
