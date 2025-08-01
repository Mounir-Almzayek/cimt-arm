import 'package:cimt/app/theme/app_colors.dart';
import 'package:cimt/data/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/models/session.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/routes/routes.dart';

class StagePartsScreen extends GetView<GlobalController> {
  const StagePartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stage stage = controller.stage!;
    final sessions = stage.sessions;
    int completedSessions = sessions
        .where((session) => session.parts.every((part) =>
            part.exercises.every((ex) => ex.completionTimestamps.isNotEmpty)))
        .length;
    double progress =
        sessions.isEmpty ? 0 : completedSessions / sessions.length;
    return Scaffold(
      appBar: AppBar(
          title:
              Text(stage.difficulty.name, style: TextStyle(fontSize: 20.sp))),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final isCompleted = session.parts.every((part) => part.exercises
                    .every((ex) => ex.completionTimestamps.isNotEmpty));
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title:
                          Text(session.name, style: TextStyle(fontSize: 16.sp)),
                      leading: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 24.sp,
                      ),
                      onTap: () {
                        controller.session = session;
                        Get.toNamed(AppRoutes.sessionParts);
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SessionPartsScreen extends StatelessWidget {
  const SessionPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    final Session session = global.session!;
    final parts = session.parts;
    int completedParts = parts
        .where((part) =>
            part.exercises.every((ex) => ex.completionTimestamps.isNotEmpty))
        .length;
    double progress = parts.isEmpty ? 0 : completedParts / parts.length;
    return Scaffold(
      appBar:
          AppBar(title: Text(session.name, style: TextStyle(fontSize: 20.sp))),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: Colors.grey[300],
              color: AppColors.lightBlueAccent,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: parts.length,
              itemBuilder: (context, index) {
                final part = parts[index];
                final isCompleted = part.exercises
                    .every((ex) => ex.completionTimestamps.isNotEmpty);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(part.name, style: TextStyle(fontSize: 16.sp)),
                      leading: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 24.sp,
                      ),
                      onTap: () {
                        global.part = part;
                        Get.toNamed(AppRoutes.exerciseDetails);
                      },
                      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
