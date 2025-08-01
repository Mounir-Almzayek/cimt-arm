import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cimt/presentation/controllers/reports_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsScreen extends StatelessWidget {
  final ReportsController controller = Get.put(ReportsController());

  ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('التقارير', style: TextStyle(fontSize: 20.sp))),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return Center(
              child: Text('حدث خطأ أثناء تحميل البيانات',
                  style: TextStyle(fontSize: 16.sp)));
        }
        final users = controller.users;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text('توزيع التقييمات',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18.sp)),
              ),
              SizedBox(
                height: 320.h,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: [
                        (List.generate(5, (i) => controller.countByStars(i + 1))
                                    .reduce((a, b) => a > b ? a : b) +
                                1)
                            .toDouble(),
                        5.0
                      ].reduce((a, b) => a > b ? a : b),
                      barTouchData: BarTouchData(enabled: true),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36.w,
                            getTitlesWidget: (value, meta) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            interval: 1,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final star = value.toInt();
                              if (star < 1 || star > 5) return const SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(top: 0.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('$star',
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold)),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16.sp),
                                  ],
                                ),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(5, (i) {
                        final star = i + 1;
                        final count = controller.countByStars(star);
                        return BarChartGroupData(
                          x: star,
                          barRods: [
                            BarChartRodData(
                              toY: count.toDouble(),
                              width: 22.w,
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.lightBlueAccent,
                                  AppColors.primaryColor,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              rodStackItems: [],
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: [
                                  (List.generate(
                                                  5,
                                                  (i) => controller
                                                      .countByStars(i + 1))
                                              .reduce((a, b) => a > b ? a : b) +
                                          1)
                                      .toDouble(),
                                  5.0
                                ].reduce((a, b) => a > b ? a : b),
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                          barsSpace: 8.w,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text('آراء المستخدمين',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18.sp)),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, __) => Divider(height: 1.h),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: Icon(Icons.person,
                        color: AppColors.lightBlueAccent, size: 28.sp),
                    title: Text(user.name, style: TextStyle(fontSize: 16.sp)),
                    subtitle: Text(
                        user.ratingFeedback?.isNotEmpty == true
                            ? user.ratingFeedback!
                            : 'بدون تعليق',
                        style: TextStyle(fontSize: 14.sp)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(user.ratingStars?.toString() ?? '',
                            style: TextStyle(fontSize: 14.sp)),
                        Icon(Icons.star, color: Colors.amber, size: 18.sp),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}
