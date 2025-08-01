import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/app/routes/routes.dart';

class FreeTrainingSectionsScreen extends StatelessWidget {
  const FreeTrainingSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    return Scaffold(
      appBar: AppBar(title: const Text('أقسام التدريب الحر')),
      body: Obx(() {
        final user = global.currentUser.value;
        final sections = user?.sections ?? [];
        if (sections.isEmpty) {
          return const Center(child: Text('لا يوجد أقسام متاحة'));
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            final color =
                Colors.primaries[index % Colors.primaries.length].shade300;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: () {
                  global.section = section;
                  Get.toNamed(AppRoutes.freeTrainingLevels);
                },
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: color.withOpacity(0.18),
                          child:
                              Icon(Icons.category, color: color, size: 32.sp),
                        ),
                        SizedBox(width: 18.w),
                        Expanded(
                          child: Text(
                            section.name,
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[400], size: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
