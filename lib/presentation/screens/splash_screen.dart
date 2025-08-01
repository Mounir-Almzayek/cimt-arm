import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async'; // Added for Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _displayedArabicText = '';
  String _displayedEnglishText = '';
  String _arabicText = 'تأهيلٌ ينبضُ بالحركةِ…\nوروابطٌ تولدُ بالمتعةِ';
  String _englishText = 'Rehab through movement...\nReconnect through joy';
  int _currentIndex = 0;
  bool _isArabicComplete = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the fade animation
    _animationController.forward();

    // Start typing after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _startTyping();
    });
  }

  void _startTyping() {
    const typingSpeed = Duration(milliseconds: 100);

    Timer.periodic(typingSpeed, (timer) {
      if (!_isArabicComplete) {
        // Type Arabic text first
        if (_currentIndex < _arabicText.length) {
          setState(() {
            _displayedArabicText = _arabicText.substring(0, _currentIndex + 1);
            _currentIndex++;
          });
        } else {
          // Arabic text is complete, start English text
          setState(() {
            _isArabicComplete = true;
            _currentIndex = 0;
          });
        }
      } else {
        // Type English text
        if (_currentIndex < _englishText.length) {
          setState(() {
            _displayedEnglishText =
                _englishText.substring(0, _currentIndex + 1);
            _currentIndex++;
          });
        } else {
          // Both texts are complete
          timer.cancel();
          setState(() {});

          // Typing is complete

          // Wait 2 seconds after typing is complete, then navigate
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed('/users');
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueAccent, // Blue background
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo2.png',
                height: 120.h,
                width: 120.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40.h),

              // Typing text
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // Arabic text
                        Text(
                          _displayedArabicText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                        SizedBox(height: 30.h),
                        // English text
                        Text(
                          _displayedEnglishText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
