import 'package:cimt/app/routes/routes.dart';
import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseTimerScreen extends StatefulWidget {
  const ExerciseTimerScreen({super.key});

  @override
  State<ExerciseTimerScreen> createState() => _ExerciseTimerScreenState();
}

class _ExerciseTimerScreenState extends State<ExerciseTimerScreen> {
  late ExerciseFlowController controller;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ExerciseFlowController>();
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    // For regular exercises, use exercise duration
    final exercise = controller.currentExercise;
    if (exercise != null) {
      _remainingSeconds = exercise.executionTime.inSeconds;
      _startTimer();
    } else {
      // Handle null exercise case
      Get.back();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds == 0) {
          _onTimerComplete();
        }
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _onTimerComplete() async {
    _timer?.cancel();
    await controller.markExerciseCompleted();
    controller.startRest();
    Get.offNamed(AppRoutes.restTimer);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = controller.currentExercise;
    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ', style: TextStyle(fontSize: 18.sp))),
        body: Center(
          child: Text('لا يوجد تمرين متاح', style: TextStyle(fontSize: 16.sp)),
        ),
      );
    }

    final total = exercise.executionTime.inSeconds;
    final progress = (total - _remainingSeconds) / total;

    return Scaffold(
      appBar: AppBar(
          title: Text('مؤقت التمرين', style: TextStyle(fontSize: 18.sp))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 230.w,
                  height: 230.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14.w,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.lightBlueAccent),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('وقت التنفيذ',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey)),
                    SizedBox(height: 8.h),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 56.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50.h),
            ElevatedButton.icon(
              onPressed: _togglePause,
              icon:
                  Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 22.sp),
              label: Text(_isPaused ? 'استكمال' : 'إيقاف مؤقت',
                  style: TextStyle(fontSize: 15.sp)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(140.w, 44.h),
                backgroundColor:
                    _isPaused ? Colors.orangeAccent : AppColors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
