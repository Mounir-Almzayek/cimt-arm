import 'package:get/get.dart';
import 'package:cimt/data/models/user.dart';
import 'package:cimt/data/repository/user_repository.dart';
import 'package:cimt/app/utils/async_manager.dart';

class UserController extends GetxController {
  final AsyncManager<List<User>> usersManager =
      AsyncManager<List<User>>(initialData: []).obs();
  List<User> get users => usersManager.data ?? [];
  bool get isLoading => usersManager.isLoading;
  Object? get error => usersManager.error;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    usersManager.observeAsync(
      task: (_) => UserRepository.getAllUsers(),
      onSuccess: (data) {
        usersManager.refresh();
      },
      onError: (error) {
        usersManager.refresh();
      },
    );
  }

  Future<void> addUser(String name) async {
    await usersManager.observeAsync(
      task: (_) async {
        await UserRepository.createUser(userName: name);
        return await UserRepository.getAllUsers();
      },
      onSuccess: (data) {
        usersManager.refresh();
      },
      onError: (error) {
        usersManager.refresh();
      },
    );
  }

  Future<void> removeUser(User user) async {
    await usersManager.observeAsync(
      task: (_) async {
        await UserRepository.deleteUser(user.id);
        return await UserRepository.getAllUsers();
      },
      onSuccess: (data) {
        usersManager.refresh();
      },
      onError: (error) {
        usersManager.refresh();
      },
    );
  }

  Future<void> removeAllUsers() async {
    await usersManager.observeAsync(
      task: (_) async {
        await UserRepository.deleteAllUsers();
        return await UserRepository.getAllUsers();
      },
      onSuccess: (data) {
        usersManager.refresh();
      },
      onError: (error) {
        usersManager.refresh();
      },
    );
  }
}
