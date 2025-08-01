import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Beiruti',
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Beiruti'),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBlueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'Beiruti',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          iconColor: Colors.white,
          textStyle: TextStyle(
            fontFamily: 'Beiruti',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: 'Beiruti',
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: TextStyle(
            fontFamily: 'Beiruti',
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
              const BorderSide(color: AppColors.lightBlueAccent, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.grey, fontSize: 14.sp),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightBlueAccent,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
