import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';
import 'app/global_binding.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Fitness App",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialBinding: GlobalBinding(),
          locale: const Locale('ar'),
        );
      },
    );
  }
}
