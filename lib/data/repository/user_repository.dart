import 'dart:convert';
import 'dart:io';
import 'package:cimt/data/models/stage.dart';
import 'package:cimt/app/utils/file_utils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cimt/data/models/user.dart';
import 'package:cimt/data/models/workout_section.dart';
import 'package:cimt/data/models/exercise.dart';
import 'package:cimt/data/models/session.dart';
import 'package:cimt/data/models/part.dart';
import 'package:intl/intl.dart';

class UserRepository {
  static const String _templateProgramAssetPath =
      'assets/program_template_sections.json';

  static Future<List<WorkoutSection>> _loadProgramTemplateSections() async {
    final String jsonString =
        await rootBundle.loadString(_templateProgramAssetPath);
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((sectionJson) =>
            WorkoutSection.fromJson(sectionJson as Map<String, dynamic>))
        .toList();
  }

  static Future<User?> getUser(String userId, {String? defaultUserName}) async {
    final file = await FileUtils.getUserFile(userId);

    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        final userJson = json.decode(contents) as Map<String, dynamic>;
        print("User data loaded for $userId from file.");
        return User.fromJson(userJson);
      } else {
        print("User file for $userId is empty. Treating as new user.");
      }
    }

    print(
        "No existing data for $userId. Creating new user with template sections.");
    List<WorkoutSection> defaultSections = await _loadProgramTemplateSections();

    if (defaultSections.isEmpty && _templateProgramAssetPath.isNotEmpty) {
      // تحقق إضافي
      print(
          "Failed to load program template sections or template is empty. Cannot create new user if template is required.");
      return null;
    }

    final newUser = User(
      id: userId,
      name: defaultUserName ?? "مستخدم جديد",
      sections: defaultSections,
    );

    await saveUser(newUser);
    print("New user $userId created and saved with default sections.");
    return newUser;
  }

  static Future<void> saveUser(User user) async {
    final file = await FileUtils.getUserFile(user.id);
    final userJsonString = json.encode(user.toJson());
    await file.writeAsString(userJsonString);
    print("User data saved for ${user.id}.");
  }

  static Future<User?> updateUserName(String userId, String newName) async {
    User? currentUser = await getUser(userId);
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(name: newName);
      await saveUser(updatedUser);
      print("User name updated for $userId.");
      return updatedUser;
    }
    return null;
  }

  static Future<User?> recordExerciseCompletionById(
    String userId,
    String sectionId,
    String stageId,
    String exerciseId,
  ) async {
    User? user = await getUser(userId);
    if (user == null) {
      print("Cannot record completion: User $userId not found.");
      return null;
    }

    bool exerciseFoundAndUpdated = false;
    List<WorkoutSection> updatedSections =
        List.from(user.sections.map((section) {
      if (section.id == sectionId) {
        List<Stage> updatedStages = List.from(section.stages.map((stage) {
          if (stage.id == stageId) {
            // Traverse sessions > parts > exercises
            List<Session> updatedSessions =
                List.from(stage.sessions.map((session) {
              List<Part> updatedParts = List.from(session.parts.map((part) {
                List<Exercise> updatedExercises = List.from(part.exercises);
                final exerciseIndex =
                    updatedExercises.indexWhere((ex) => ex.id == exerciseId);
                if (exerciseIndex != -1) {
                  Exercise originalExercise = updatedExercises[exerciseIndex];
                  originalExercise.markAsCompletedNow();
                  updatedExercises[exerciseIndex] = originalExercise;
                  exerciseFoundAndUpdated = true;
                }
                return part.copyWith(exercises: updatedExercises);
              }));
              return session.copyWith(parts: updatedParts);
            }));
            return stage.copyWith(sessions: updatedSessions);
          }
          return stage;
        }));
        return section.copyWith(stages: updatedStages);
      }
      return section;
    }));

    if (exerciseFoundAndUpdated) {
      final updatedUser = user.copyWith(sections: updatedSections);
      await saveUser(updatedUser);
      print(
          "Exercise with ID '$exerciseId' completion recorded for user $userId.");
      return updatedUser;
    } else {
      print(
          "Exercise with ID '$exerciseId' not found for user $userId in section '$sectionId' and stage '$stageId'.");
      return user;
    }
  }

  static Future<User?> createUser({
    required String userName,
    bool forceCreate = false,
  }) async {
    print("Preparing to create new user object for name '$userName'.");
    List<WorkoutSection> defaultSections = await _loadProgramTemplateSections();

    if (defaultSections.isEmpty && _templateProgramAssetPath.isNotEmpty) {
      print(
          "Failed to load program template sections for '$userName'. Cannot create user if template is required.");
      return null;
    }

    final newUser = User(
      name: userName,
      sections: defaultSections,
    );
    print(
        "User object created for '$userName' with auto-generated ID: ${newUser.id}.");

    final file = await FileUtils.getUserFile(newUser.id);

    if (!forceCreate && await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        print(
            "Critical Warning: File for auto-generated user ID ${newUser.id} ('$userName') already exists and is not empty. This should be extremely rare. Returning existing user data from file.");
        final userJson = json.decode(contents) as Map<String, dynamic>;
        return User.fromJson(userJson);
      } else {
        print(
            "User file for ${newUser.id} ('$userName') exists but is empty. Proceeding with saving new user data.");
      }
    }

    await saveUser(newUser);
    print(
        "New user '${newUser.name}' (ID: ${newUser.id}) created and saved successfully.");
    return newUser;
  }

  static Future<bool> deleteUser(String userId) async {
    final file = await FileUtils.getUserFile(userId);
    if (await file.exists()) {
      await file.delete();
      print("User data for $userId deleted successfully.");
      return true;
    } else {
      print("User data for $userId not found. No action taken.");
      return true;
    }
  }

  static Future<bool> deleteAllUsers() async {
    final path = await FileUtils.localPath;
    final directory = Directory(path);

    if (await directory.exists()) {
      final List<FileSystemEntity> entities = await directory.list().toList();
      int deleteCount = 0;
      for (FileSystemEntity entity in entities) {
        if (entity is File &&
            entity.path.endsWith('.json') &&
            entity.path.contains('/user_')) {
          try {
            await entity.delete();
            deleteCount++;
            print("Deleted file: ${entity.path}");
          } catch (e) {
            print("Error deleting file ${entity.path}: $e");
          }
        }
      }
      print("$deleteCount user data file(s) deleted from $path.");
      return true;
    } else {
      print("Application documents directory not found. No users to delete.");
      return true;
    }
  }

  static Future<List<User>> getAllUsers() async {
    List<User> users = [];
    final String path = await FileUtils.localPath;
    final directory = Directory(path);

    if (await directory.exists()) {
      final List<FileSystemEntity> entities = await directory.list().toList();

      for (FileSystemEntity entity in entities) {
        if (entity is File &&
            entity.path.endsWith('.json') &&
            entity.path.contains('/user_')) {
          final String contents = await entity.readAsString();
          if (contents.isNotEmpty) {
            final Map<String, dynamic> userJson =
                json.decode(contents) as Map<String, dynamic>;
            users.add(User.fromJson(userJson));
          }
        }
      }
      print("Found ${users.length} users.");
    } else {
      print("Application documents directory not found. No users to load.");
    }
    return users;
  }

  static Future<List<DateTime>> getAllTrainingDaysForUser(String userId) async {
    List<DateTime> trainingDays = [];
    User? user = await getUser(userId);

    if (user != null) {
      for (var section in user.sections) {
        for (var stage in section.stages) {
          for (var session in stage.sessions) {
            for (var part in session.parts) {
              for (var exercise in part.exercises) {
                for (var timestamp in exercise.completionTimestamps) {
                  DateTime dayOnly =
                      DateTime(timestamp.year, timestamp.month, timestamp.day);
                  trainingDays.add(dayOnly);
                }
              }
            }
          }
        }
      }
    } else {
      print("User with ID $userId not found. Cannot retrieve training days.");
    }
    return trainingDays;
  }

  static Future<List<DateTime>> getUniqueTrainingDaysForUser(
      String userId) async {
    List<DateTime> allTrainingDays = await getAllTrainingDaysForUser(userId);
    if (allTrainingDays.isEmpty) {
      return [];
    }

    Set<String> uniqueDayStrings = Set<String>();
    for (var day in allTrainingDays) {
      uniqueDayStrings.add(DateFormat('yyyy-MM-dd')
          .format(DateTime(day.year, day.month, day.day)));
    }

    List<DateTime> uniqueDaysList = uniqueDayStrings
        .map((dateString) => DateFormat('yyyy-MM-dd').parse(dateString))
        .toList();

    uniqueDaysList.sort((a, b) => a.compareTo(b));

    return uniqueDaysList;
  }

  static Future<User?> addOrUpdateUserRating({
    required String userId,
    required int stars,
    String? feedback,
  }) async {
    User? user = await getUser(userId);

    if (user == null) {
      print("User $userId not found. Cannot add rating.");
      return null;
    }

    if (!user.isEntireProgramCompleted) {
      print(
          "User $userId has not completed the entire program. Rating cannot be added.");
      return null;
    }

    if (stars < 1 || stars > 5) {
      print("Invalid star rating: $stars. Must be between 1 and 5.");
      return null;
    }

    User updatedUser = user.copyWith(
      ratingStars: stars,
      ratingFeedback: feedback,
      allowNullRatingFeedback: feedback == null || feedback.isEmpty,
    );

    await saveUser(updatedUser);
    print(
        "Rating added/updated for user $userId: $stars stars, Feedback: '$feedback'");
    return updatedUser;
  }

  static Future<List<User>> getUsersWithRatings() async {
    List<User> usersWithRatings = [];
    List<User> allUsers = await getAllUsers();
    usersWithRatings =
        allUsers.where((user) => user.ratingStars != null).toList();
    print(
        "Found ${usersWithRatings.length} users who have submitted a rating.");
    usersWithRatings.sort((a, b) => b.ratingStars!.compareTo(a.ratingStars!));
    return usersWithRatings;
  }

  static int countUsersByStarRating({
    required List<User> usersList,
    required int starRatingToCount,
  }) {
    int count = 0;
    if (starRatingToCount < 1 || starRatingToCount > 5) {
      print(
          "Warning: starRatingToCount ($starRatingToCount) is outside the typical 1-5 range.");
    }

    for (var user in usersList) {
      if (user.ratingStars != null && user.ratingStars == starRatingToCount) {
        count++;
      }
    }
    return count;
  }

  static Future<List<Exercise>> getAllExercisesForUserFlat(
      String userId) async {
    List<Exercise> collectedExercises = [];
    User? user = await getUser(userId);

    if (user != null) {
      for (var section in user.sections) {
        for (var stage in section.stages) {
          for (var session in stage.sessions) {
            for (var part in session.parts) {
              collectedExercises.addAll(part.exercises);
            }
          }
        }
      }
    } else {
      print("User with ID $userId not found. Cannot retrieve exercises.");
    }
    return collectedExercises;
  }
}
