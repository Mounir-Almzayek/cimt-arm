import 'package:cimt/app/routes/routes.dart';
import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:cimt/data/repository/user_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/data/models/session.dart';

class StructuredTrainingScreen extends StatelessWidget {
  const StructuredTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Get.find<GlobalController>();
    final user = global.user;
    final sections = user?.sections ?? [];
    // جمع كل الجلسات مع اسم المستوى واسم القسم
    final List<_SessionWithStageSection> allSessions = [];
    for (final section in sections) {
      for (final stage in section.stages) {
        for (final session in stage.sessions) {
          allSessions.add(_SessionWithStageSection(
            session: session,
            stageName: stage.difficulty.name,
            sectionName: section.name,
          ));
        }
      }
    }

    // ترتيب يدوي للجلسات حسب الاسم
    final order = [
      'الجلسةالأولى',
      'الجلسةالثانية',
      'الجلسةالثالثة',
      'الجلسةالرابعة',
      'الجلسةالخامسة',
      'الجلسةالسادسة',
      'الجلسةالسابعة',
      'الجلسةالثامنة',
      'الجلسةالتاسعة',
      'الجلسةالعاشرة',
    ];
    allSessions.sort((a, b) {
      int aIndex =
          order.indexWhere((o) => a.session.name.replaceAll(' ', '') == o);
      int bIndex =
          order.indexWhere((o) => b.session.name.replaceAll(' ', '') == o);
      return aIndex.compareTo(bIndex);
    });

    // منطق القفل: الجلسة الأولى مفتوحة، كل جلسة بعدها تُفتح فقط إذا السابقة مكتملة
    bool isSessionCompleted(Session session) {
      return session.parts.every((part) =>
          part.exercises.every((ex) => ex.completionTimestamps.isNotEmpty));
    }

    bool allCompleted = allSessions.isNotEmpty &&
        allSessions.every((s) => isSessionCompleted(s.session));
    int completedSessions =
        allSessions.where((s) => isSessionCompleted(s.session)).length;
    double progress =
        allSessions.isEmpty ? 0 : completedSessions / allSessions.length;

    return Scaffold(
      appBar:
          AppBar(title: Text('كل الجلسات', style: TextStyle(fontSize: 20.sp))),
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
              itemCount: allSessions.length,
              itemBuilder: (context, index) {
                final item = allSessions[index];
                bool locked = false;
                if (index > 0) {
                  final prevSession = allSessions[index - 1].session;
                  locked = !isSessionCompleted(prevSession);
                }
                final isCompleted = isSessionCompleted(item.session);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(item.session.name,
                          style: TextStyle(fontSize: 16.sp)),
                      subtitle: Text('القسم: ${item.sectionName}',
                          style: TextStyle(fontSize: 14.sp)),
                      leading: Icon(
                        locked
                            ? Icons.lock
                            : (isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked),
                        color: locked
                            ? Colors.grey
                            : (isCompleted ? Colors.green : Colors.grey),
                        size: 24.sp,
                      ),
                      enabled: !locked,
                      onTap: locked
                          ? null
                          : () {
                              final global = Get.find<GlobalController>();
                              global.session = item.session;
                              Get.toNamed(AppRoutes.sessionParts);
                            },
                      trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
                    ),
                  ),
                );
              },
            ),
          ),
          if (allCompleted)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton.icon(
                icon: Icon(Icons.star, color: Colors.amber, size: 24.sp),
                label: Text('قيّم البرنامج', style: TextStyle(fontSize: 16.sp)),
                onPressed: () async {
                  int stars = 5;
                  String feedback = '';
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('تقييم البرنامج',
                          style: TextStyle(fontSize: 18.sp)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                5,
                                (i) => IconButton(
                                      icon: Icon(
                                        i < stars
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 28.sp,
                                      ),
                                      onPressed: () {
                                        stars = i + 1;
                                        (context as Element).markNeedsBuild();
                                      },
                                    )),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'تعليق (اختياري)',
                                hintStyle: TextStyle(fontSize: 14.sp)),
                            style: TextStyle(fontSize: 16.sp),
                            onChanged: (val) => feedback = val,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child:
                              Text('إلغاء', style: TextStyle(fontSize: 14.sp)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (user != null) {
                              await UserRepository.addOrUpdateUserRating(
                                userId: user.id,
                                stars: stars,
                                feedback: feedback,
                              );
                              global.user = user.copyWith(
                                  ratingStars: stars, ratingFeedback: feedback);
                            }
                            Navigator.of(context).pop();
                            Get.snackbar('تم', 'تم حفظ تقييمك بنجاح');
                          },
                          child:
                              Text('إرسال', style: TextStyle(fontSize: 14.sp)),
                        ),
                      ],
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

class _SessionWithStageSection {
  final Session session;
  final String stageName;
  final String sectionName;
  _SessionWithStageSection(
      {required this.session,
      required this.stageName,
      required this.sectionName});
}
