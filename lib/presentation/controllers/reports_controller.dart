import 'package:get/get.dart';
import 'package:cimt/data/models/user.dart';
import 'package:cimt/data/repository/user_repository.dart';
import 'package:cimt/app/utils/async_manager.dart';

class ReportsController extends GetxController {
  final AsyncManager<List<User>> usersManager =
      AsyncManager<List<User>>(initialData: []).obs();
  List<User> get users => usersManager.data ?? [];
  bool get isLoading => usersManager.isLoading;
  Object? get error => usersManager.error;

  @override
  void onInit() {
    super.onInit();
    fetchUsersWithRatings();
  }

  void fetchUsersWithRatings() {
    usersManager.observeAsync(
      task: (_) => UserRepository.getUsersWithRatings(),
    );
  }

  int countByStars(int stars) {
    return UserRepository.countUsersByStarRating(
        usersList: users, starRatingToCount: stars);
  }
}
