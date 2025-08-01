// import 'package:cimt/presentation/screens/exercise_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cimt/app/global_controller.dart';

// class FreeTrainingPartsScreen extends StatelessWidget {
//   const FreeTrainingPartsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final global = Get.find<GlobalController>();
//     return Scaffold(
//       appBar: AppBar(title: const Text('أجزاء المرحلة')),
//       body: Obx(() {
//         final stage = global.selectedStage.value;
//         final parts = stage?.sessions.expand((s) => s.parts).toList() ?? [];
//         if (parts.isEmpty) {
//           return const Center(child: Text('لا يوجد أجزاء متاحة'));
//         }
//         return ListView.builder(
//           itemCount: parts.length,
//           itemBuilder: (context, index) {
//             final part = parts[index];
//             return ListTile(
//               title: Text(part.name),
//               onTap: () {
//                 global.selectedPart.value = part;
//                 Get.to(() => ExerciseDetailsScreen());
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
