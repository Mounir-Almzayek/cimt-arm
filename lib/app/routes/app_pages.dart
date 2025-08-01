import 'package:get/get.dart';
import 'package:cimt/app/routes/routes.dart';
import 'package:cimt/presentation/screens/splash_screen.dart';
import 'package:cimt/presentation/screens/user_screen.dart';
import 'package:cimt/presentation/screens/user_action_screen.dart';
import 'package:cimt/presentation/screens/free_training_levels_screen.dart';
import 'package:cimt/presentation/screens/stage_parts_screen.dart';
import 'package:cimt/presentation/screens/exercise_details_screen.dart';
import 'package:cimt/presentation/screens/exercise_timer_screen.dart';
import 'package:cimt/presentation/screens/rest_timer_screen.dart';
import 'package:cimt/presentation/screens/structured_training_screen.dart';
import 'package:cimt/presentation/screens/archive_screen.dart';
import 'package:cimt/presentation/screens/reports_screen.dart';
import 'package:cimt/presentation/screens/training_type_selection_screen.dart';
import 'package:cimt/presentation/screens/free_training_sections_screen.dart';
import 'package:cimt/presentation/screens/instructions_screen.dart';
import 'package:cimt/presentation/bindings/user_binding.dart';
import 'package:cimt/presentation/bindings/reports_binding.dart';
import 'package:cimt/presentation/bindings/exercise_flow_binding.dart';

class AppPages {
  static const INITIAL = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.userScreen,
      page: () => UserScreen(),
      binding: UserBinding(),
    ),
    GetPage(
      name: AppRoutes.userAction,
      page: () => UserActionScreen(),
    ),
    GetPage(
      name: AppRoutes.freeTrainingLevels,
      page: () => FreeTrainingLevelsScreen(),
    ),
    GetPage(
      name: AppRoutes.stageParts,
      page: () => StagePartsScreen(),
    ),
    GetPage(
      name: AppRoutes.sessionParts,
      page: () => SessionPartsScreen(),
    ),
    GetPage(
      name: AppRoutes.exerciseDetails,
      page: () => ExerciseDetailsScreen(),
      binding: ExerciseFlowBinding(),
    ),
    GetPage(
      name: AppRoutes.exerciseTimer,
      page: () => ExerciseTimerScreen(),
      binding: ExerciseFlowBinding(),
    ),
    GetPage(
      name: AppRoutes.restTimer,
      page: () => RestTimerScreen(),
      binding: ExerciseFlowBinding(),
    ),
    GetPage(
        name: AppRoutes.structuredTraining,
        page: () => StructuredTrainingScreen()),
    GetPage(
      name: AppRoutes.archive,
      page: () => ArchiveScreen(),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => ReportsScreen(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: AppRoutes.trainingTypeSelection,
      page: () => TrainingTypeSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.freeTrainingSections,
      page: () => FreeTrainingSectionsScreen(),
    ),
    GetPage(
      name: AppRoutes.instructions,
      page: () => InstructionsScreen(),
    ),
  ];
}
