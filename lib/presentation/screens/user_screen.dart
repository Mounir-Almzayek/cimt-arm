import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimt/presentation/controllers/user_controller.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/routes/routes.dart';

class UserScreen extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10.w),
          child: Image.asset(
            'assets/logo2.png',
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
          ),
        ),
        title: Text('المستخدمون', style: TextStyle(fontSize: 20.sp)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.sp),
            onPressed: () {
              controller.fetchUsers();
            },
            tooltip: 'تحديث',
          ),
          IconButton(
            icon: Icon(Icons.bar_chart, size: 24.sp),
            onPressed: () {
              Get.toNamed(AppRoutes.reports);
            },
            tooltip: 'التقارير',
          ),
          IconButton(
            icon: Icon(Icons.delete_forever, size: 24.sp),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('تأكيد الحذف', style: TextStyle(fontSize: 18.sp)),
                  content: Text('هل أنت متأكد أنك تريد حذف جميع المستخدمين؟',
                      style: TextStyle(fontSize: 15.sp)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('إلغاء', style: TextStyle(fontSize: 14.sp)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('حذف', style: TextStyle(fontSize: 14.sp)),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                controller.removeAllUsers();
              }
            },
            tooltip: 'حذف الكل',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return Center(
              child: Text('حدث خطأ أثناء تحميل المستخدمين',
                  style: TextStyle(fontSize: 16.sp)));
        }
        if (controller.users.isEmpty) {
          return Center(
              child: Text('لا يوجد مستخدمون محفوظون',
                  style: TextStyle(fontSize: 16.sp)));
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Dismissible(
                key: ValueKey(user.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
                ),
                onDismissed: (_) => controller.removeUser(user),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(user.name, style: TextStyle(fontSize: 16.sp)),
                    onTap: () {
                      final global = Get.find<GlobalController>();
                      global.user = user;
                      Get.toNamed(AppRoutes.userAction);
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nameController = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title:
                  Text('إضافة مستخدم جديد', style: TextStyle(fontSize: 18.sp)),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'اسم المستخدم',
                    hintStyle: TextStyle(fontSize: 14.sp)),
                autofocus: true,
                style: TextStyle(fontSize: 16.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('إلغاء', style: TextStyle(fontSize: 14.sp)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.of(context).pop(name);
                    }
                  },
                  child: Text('إضافة', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          );
          if (result != null && result.isNotEmpty) {
            await controller.addUser(result);
          }
        },
        child: Icon(Icons.add, size: 28.sp),
        tooltip: 'إضافة مستخدم',
      ),
    );
  }
}
