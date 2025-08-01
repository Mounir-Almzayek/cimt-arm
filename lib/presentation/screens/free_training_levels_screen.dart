import 'package:cimt/data/models/difficulty_level.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/routes/routes.dart';

class FreeTrainingLevelsScreen extends StatelessWidget {
  const FreeTrainingLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    return Scaffold(
      appBar:
          AppBar(title: Text('المستويات', style: TextStyle(fontSize: 20.sp))),
      body: Obx(() {
        final section = global.selectedSection.value;
        final stages = section?.stages ?? [];
        if (stages.isEmpty) {
          return Center(
              child: Text('لا يوجد مستويات متاحة',
                  style: TextStyle(fontSize: 16.sp)));
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          itemCount: stages.length,
          itemBuilder: (context, index) {
            final stage = stages[index];
            final color =
                Colors.primaries[index % Colors.primaries.length].shade300;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap: () {
                  global.stage = stage;
                  Get.toNamed(AppRoutes.stageParts);
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
                          child: Icon(Icons.emoji_events,
                              color: color, size: 32.sp),
                        ),
                        SizedBox(width: 18.w),
                        Expanded(
                          child: Text(
                            stage.difficulty.arabicName,
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
