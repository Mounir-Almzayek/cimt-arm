import 'package:get/get.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/repository/user_repository.dart';
import 'package:cimt/app/utils/async_manager.dart';

class ArchiveController extends GetxController {
  final global = Get.find<GlobalController>();
  Rx<DateTime> currentMonth = DateTime.now().obs;
  final AsyncManager<List<DateTime>> trainingDaysManager =
      AsyncManager<List<DateTime>>(initialData: []).obs();

  List<DateTime> get trainingDays => trainingDaysManager.data ?? [];
  bool get isLoading => trainingDaysManager.isLoading;
  Object? get error => trainingDaysManager.error;

  @override
  void onInit() {
    super.onInit();
    fetchTrainingDays();
  }

  void fetchTrainingDays() async {
    final user = global.user;
    if (user != null) {
      await trainingDaysManager.observeAsync(
        task: (_) => UserRepository.getAllTrainingDaysForUser(user.id),
      );
    }
  }

  void nextMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  void previousMonth() {
    currentMonth.value =
        DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  bool isTrainingDay(DateTime day) {
    return trainingDays.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day);
  }
}
