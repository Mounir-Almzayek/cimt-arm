import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cimt/presentation/controllers/archive_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArchiveScreen extends StatelessWidget {
  final ArchiveController controller = Get.put(ArchiveController());

  ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأرشيف', style: TextStyle(fontSize: 20.sp)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'تحديث',
            onPressed: () {
              controller.fetchTrainingDays();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return Center(child: Text('حدث خطأ أثناء تحميل الأيام'));
        }
        final month = controller.currentMonth.value;
        final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
        final firstDayOfMonth = DateTime(month.year, month.month, 1);
        final weekDayOffset = firstDayOfMonth.weekday % 7;
        final days = List.generate(
            daysInMonth, (i) => DateTime(month.year, month.month, i + 1));
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 22.sp),
                    onPressed: controller.previousMonth,
                  ),
                  Text(
                    DateFormat.yMMMM('ar').format(month),
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 22.sp),
                    onPressed: controller.nextMonth,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ح', style: TextStyle(fontSize: 14.sp)),
                  Text('ن', style: TextStyle(fontSize: 14.sp)),
                  Text('ث', style: TextStyle(fontSize: 14.sp)),
                  Text('ر', style: TextStyle(fontSize: 14.sp)),
                  Text('خ', style: TextStyle(fontSize: 14.sp)),
                  Text('ج', style: TextStyle(fontSize: 14.sp)),
                  Text('س', style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4.h,
                  crossAxisSpacing: 4.w,
                ),
                itemCount: weekDayOffset + days.length,
                itemBuilder: (context, index) {
                  if (index < weekDayOffset) {
                    return const SizedBox();
                  }
                  final day = days[index - weekDayOffset];
                  final isTrained = controller.isTrainingDay(day);
                  return Container(
                    decoration: BoxDecoration(
                      color: isTrained
                          ? AppColors.lightBlueAccent
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isTrained ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
