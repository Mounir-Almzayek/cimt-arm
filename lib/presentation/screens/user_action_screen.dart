import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/routes/routes.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/repository/user_repository.dart';

class UserActionScreen extends StatelessWidget {
  const UserActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر الإجراء', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.sp),
            onPressed: () async {
              // Refresh the current user data
              final global = Get.find<GlobalController>();
              if (global.user != null) {
                try {
                  // Fetch all users from database
                  final allUsers = await UserRepository.getAllUsers();

                  // Find the current user by ID
                  final updatedUser = allUsers.firstWhere(
                    (user) => user.id == global.user!.id,
                    orElse: () => global.user!,
                  );

                  // Update the current user with latest data
                  global.user = updatedUser;

                  Get.snackbar(
                    'تم التحديث',
                    'تم تحديث بيانات المستخدم بنجاح',
                    snackPosition: SnackPosition.TOP,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Get.snackbar(
                    'خطأ',
                    'فشل في تحديث بيانات المستخدم',
                    snackPosition: SnackPosition.TOP,
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              }
            },
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionCard(
                icon: Icons.fitness_center,
                title: 'تمرين',
                description: 'ابدأ أو أكمل برنامجك التدريبي.',
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade200],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                onTap: () {
                  Get.put(ExerciseFlowController());
                  Get.toNamed(AppRoutes.trainingTypeSelection);
                },
              ),
              SizedBox(height: 32.h),
              _ActionCard(
                icon: Icons.archive,
                title: 'الأرشيف',
                description: 'استعرض أيام التدريب السابقة.',
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Get.toNamed(AppRoutes.archive),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.r),
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34.r,
                backgroundColor: Colors.white.withOpacity(0.18),
                child: Icon(icon, color: Colors.white, size: 38.sp),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 10.h),
                    Text(description,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
