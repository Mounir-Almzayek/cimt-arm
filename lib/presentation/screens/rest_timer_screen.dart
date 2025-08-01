import 'package:cimt/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';
import 'exercise_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestTimerScreen extends StatefulWidget {
  const RestTimerScreen({super.key});

  @override
  State<RestTimerScreen> createState() => _RestTimerScreenState();
}

class _RestTimerScreenState extends State<RestTimerScreen> {
  late ExerciseFlowController controller;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ExerciseFlowController>();
    final exercise = controller.currentExercise;
    if (exercise != null) {
      _remainingSeconds = exercise.restTime.inSeconds;
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

  void _onTimerComplete() {
    _timer?.cancel();
    if (controller.isLastExercise) {
      Get.offAllNamed(AppRoutes.userScreen);
    } else {
      controller.endRest();
      Get.off(() => ExerciseDetailsScreen());
    }
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

    final total = exercise.restTime.inSeconds;
    final progress = (total - _remainingSeconds) / total;
    return Scaffold(
      appBar: AppBar(title: Text('استراحة', style: TextStyle(fontSize: 18.sp))),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('وقت الاستراحة',
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
                backgroundColor: _isPaused ? Colors.orangeAccent : Colors.green,
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

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('انتهيت!', style: TextStyle(fontSize: 20.sp))),
      body: Center(
        child: Text('مبروك! أنهيت جميع التمارين 🎉',
            style: TextStyle(fontSize: 24.sp)),
      ),
    );
  }
}
