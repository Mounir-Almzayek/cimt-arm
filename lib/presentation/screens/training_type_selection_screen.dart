import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/routes/routes.dart';

class TrainingTypeSelectionScreen extends GetView<GlobalController> {
  const TrainingTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختيار نوع التدريب', style: TextStyle(fontSize: 20.sp)),
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
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TrainingTypeCard(
              icon: Icons.flash_on,
              title: 'التدريب الحر',
              description: 'اختر أي قسم وابدأ التمرين مباشرة.',
              color: Colors.lightBlueAccent,
              onTap: () {
                controller.isFreeTraining = true;
                Get.toNamed(AppRoutes.freeTrainingSections);
              },
            ),
            SizedBox(height: 32.h),
            _TrainingTypeCard(
              icon: Icons.timeline,
              title: 'التدريب المرتب',
              description: 'تدرّب حسب المراحل والجلسات بشكل منظم.',
              color: Colors.blueAccent,
              onTap: () {
                controller.isFreeTraining = false;
                Get.toNamed(AppRoutes.structuredTraining);
              },
            ),
            SizedBox(height: 32.h),
            _TrainingTypeCard(
              icon: Icons.help_outline,
              title: 'التعليمات',
              description:
                  'البديل المنزلي للأدوات والمواد المستخدمة في التمارين.',
              color: Colors.orange,
              onTap: () => Get.toNamed(AppRoutes.instructions),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _TrainingTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 36.sp),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    SizedBox(height: 8.h),
                    Text(description,
                        style: TextStyle(
                            fontSize: 15.sp, color: Colors.grey[700])),
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
