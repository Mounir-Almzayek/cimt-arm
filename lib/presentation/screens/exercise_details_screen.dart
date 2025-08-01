import 'package:cimt/app/routes/routes.dart';
import 'package:cimt/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimt/presentation/controllers/exercise_flow_controller.dart';
import 'package:cimt/data/models/exercise.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cimt/app/global_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class ExerciseDetailsScreen extends StatelessWidget {
  final ExerciseFlowController controller = Get.find<ExerciseFlowController>();

  ExerciseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Exercise? exercise = controller.currentExercise;

      // Check if exercise is null (empty list or invalid index)
      if (exercise == null) {
        return Scaffold(
          appBar: AppBar(
            title: Text('تفاصيل التمرين', style: TextStyle(fontSize: 20.sp)),
          ),
          body: Center(
            child: Text(
              'لا توجد تمارين متاحة',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        );
      }

      final List media = exercise.media;

      // Check if exercise has video
      final hasVideo = media.any((m) => m.type == 'video');

      return PopScope(
        onPopInvoked: (didPop) {
          // Stop video when leaving the page
          // The video will be stopped automatically in dispose()
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(exercise.name, style: TextStyle(fontSize: 20.sp))),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (media.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: _MediaSlider(media: media),
                  ),
                if (media.isEmpty) SizedBox.shrink(),
                SizedBox(height: 40.h),
                if (exercise.details.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('التعليمات:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: AppColors.lightBlueAccent)),
                        ...exercise.details
                            .split('\n')
                            .expand((line) => [
                                  Text(
                                    line,
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  Opacity(
                                    opacity: 0.15,
                                    child: Divider(thickness: 1, height: 8),
                                  ),
                                ])
                            .toList()
                          ..removeLast(),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Icon(Icons.timer,
                                size: 18.sp, color: AppColors.lightBlueAccent),
                            SizedBox(width: 6.w),
                            Text('مدة التمرين: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp)),
                            if (hasVideo)
                              FutureBuilder<Duration?>(
                                future: _getVideoDuration(media),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('جاري التحميل...',
                                        style: TextStyle(fontSize: 14.sp));
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return Text(_formatDuration(snapshot.data!),
                                        style: TextStyle(fontSize: 14.sp));
                                  } else {
                                    return Text(
                                        _formatDuration(exercise.executionTime),
                                        style: TextStyle(fontSize: 14.sp));
                                  }
                                },
                              )
                            else
                              Text(_formatDuration(exercise.executionTime),
                                  style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        if (!hasVideo) ...[
                          Row(
                            children: [
                              Icon(Icons.hourglass_bottom,
                                  size: 18.sp,
                                  color: AppColors.lightBlueAccent),
                              SizedBox(width: 6.w),
                              Text('مدة الاستراحة: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp)),
                              Text(_formatDuration(exercise.restTime),
                                  style: TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                SizedBox(height: 12.h),
                if (exercise.requirements.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المعدات:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                        ...exercise.requirements.map((req) =>
                            Text('- $req', style: TextStyle(fontSize: 14.sp))),
                      ],
                    ),
                  ),
                SizedBox(height: 12.h),
                if (exercise.warnings != null && exercise.warnings!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تنبيهات:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: Colors.red)),
                        Text(exercise.warnings!,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.red)),
                      ],
                    ),
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: 16.h, top: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress indicator for free training
                Obx(() {
                  final global = Get.find<GlobalController>();
                  if (global.isFromFreeTraining.value) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous button
                          IconButton(
                            onPressed: controller.isFirstExercise
                                ? null
                                : () {
                                    // Stop video before navigating
                                    if (hasVideo) {
                                      // Video will be stopped in dispose()
                                    }
                                    controller.previousExercise();
                                  },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20.sp,
                              color: controller.isFirstExercise
                                  ? Colors.grey[400]
                                  : AppColors.lightBlueAccent,
                            ),
                          ),
                          // Next button
                          IconButton(
                            onPressed: controller.isLastExercise
                                ? null
                                : () {
                                    // Stop video before navigating
                                    if (hasVideo) {
                                      // Video will be stopped in dispose()
                                    }
                                    controller.nextExercise();
                                  },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20.sp,
                              color: controller.isLastExercise
                                  ? Colors.grey[400]
                                  : AppColors.lightBlueAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                Row(
                  children: List.generate(
                    controller.totalExercises,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: index == controller.currentExerciseIndex.value
                              ? AppColors.lightBlueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: () {
                    // Check if exercise has video
                    if (hasVideo) {
                      // For video exercises, go directly to next exercise
                      controller.setVideoExercise(true);
                      _handleVideoExercise();
                    } else {
                      // For regular exercises, go to timer
                      controller.setVideoExercise(false);
                      Get.toNamed(AppRoutes.exerciseTimer);
                    }
                  },
                  child: Text(hasVideo ? 'تحديده كمكتمل' : 'ابدأ',
                      style: TextStyle(fontSize: 16.sp)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(48.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<Duration?> _getVideoDuration(List media) async {
    for (var item in media) {
      if (item.type == 'video') {
        return await item.getVideoDuration();
      }
    }
    return null;
  }

  Future<void> _handleVideoExercise() async {
    // Mark exercise as completed
    await controller.markExerciseCompleted();

    if (controller.isLastExercise) {
      // Navigate to completion screen or back to main
      Get.back();
    } else {
      // Go to next exercise
      controller.nextExercise();
      Get.offNamed(AppRoutes.exerciseDetails);
    }
  }
}

String _formatDuration(Duration d) {
  final min = d.inMinutes;
  final sec = d.inSeconds % 60;
  if (min > 0) {
    return '$min دقيقة${sec > 0 ? ' و $sec ثانية' : ''}';
  } else {
    return '$sec ثانية';
  }
}

class _MediaSlider extends StatefulWidget {
  final List media;
  const _MediaSlider({required this.media});
  @override
  State<_MediaSlider> createState() => _MediaSliderState();
}

class _MediaSliderState extends State<_MediaSlider> {
  int _current = 0;
  VideoPlayerController? _currentVideoController;
  Timer? _progressTimer;
  bool _showControls = false;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeCurrentVideo();
  }

  @override
  void didUpdateWidget(_MediaSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media != widget.media) {
      _currentVideoController?.dispose();
      _currentVideoController = null;
      _current = 0;
      _initializeCurrentVideo();
    }
  }

  void _initializeCurrentVideo() {
    _currentVideoController?.dispose();
    final currentMedia = widget.media[_current];
    if (currentMedia.type == 'video') {
      _currentVideoController =
          VideoPlayerController.asset('assets/videos/${currentMedia.url}');
      _currentVideoController!.setLooping(true);
      _currentVideoController!.initialize().then((_) {
        if (mounted) {
          setState(() {});
          _currentVideoController!.play();
          _startProgressTimer();
        }
      });
    }
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (mounted &&
          _currentVideoController != null &&
          _currentVideoController!.value.isInitialized) {
        setState(() {});
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  // Method to stop video from outside
  void stopVideo() {
    _currentVideoController?.pause();
    _progressTimer?.cancel();
    _hideControlsTimer?.cancel();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _hideControlsTimer?.cancel();
    _currentVideoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.media.length,
          itemBuilder: (context, index, realIdx) {
            final m = widget.media[index];
            if (m.type == 'image') {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/photos/${m.url}',
                  height: 250.h,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              );
            } else if (m.type == 'video') {
              if (_current == index &&
                  _currentVideoController != null &&
                  _currentVideoController!.value.isInitialized) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showControlsTemporarily();
                          if (_currentVideoController!.value.isPlaying) {
                            _currentVideoController!.pause();
                          } else {
                            _currentVideoController!.play();
                          }
                          setState(() {});
                        },
                        child: AspectRatio(
                          aspectRatio:
                              _currentVideoController!.value.aspectRatio,
                          child: VideoPlayer(_currentVideoController!),
                        ),
                      ),
                      // Video Controls Overlay
                      if (_showControls)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Bottom controls
                              Container(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  children: [
                                    // Progress Bar
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.red,
                                        inactiveTrackColor:
                                            Colors.white.withOpacity(0.3),
                                        thumbColor: Colors.red,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6.r),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 12.r),
                                        trackHeight: 3.h,
                                      ),
                                      child: Slider(
                                        value: _currentVideoController!.value
                                                    .duration.inMilliseconds >
                                                0
                                            ? _currentVideoController!
                                                .value.position.inMilliseconds
                                                .toDouble()
                                            : 0.0,
                                        min: 0.0,
                                        max: _currentVideoController!.value
                                                    .duration.inMilliseconds >
                                                0
                                            ? _currentVideoController!
                                                .value.duration.inMilliseconds
                                                .toDouble()
                                            : 1.0,
                                        onChanged: (value) {
                                          final newPosition = Duration(
                                              milliseconds: value.toInt());
                                          _currentVideoController!
                                              .seekTo(newPosition);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    // Time and Play/Pause
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTime(_currentVideoController!
                                              .value.position),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            _currentVideoController!
                                                    .value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 32.sp,
                                          ),
                                          onPressed: () {
                                            if (_currentVideoController!
                                                .value.isPlaying) {
                                              _currentVideoController!.pause();
                                            } else {
                                              _currentVideoController!.play();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                        Text(
                                          _formatTime(_currentVideoController!
                                              .value.duration),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Play button when paused and controls are hidden
                      if (!_currentVideoController!.value.isPlaying &&
                          !_showControls)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.play_arrow,
                                color: Colors.white, size: 32.sp),
                            onPressed: () {
                              _currentVideoController!.play();
                              setState(() {});
                            },
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8.h),
                        Text('جاري تحميل الفيديو...',
                            style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                );
              }
            }
            return SizedBox(
              height: 0.h,
            );
          },
          options: CarouselOptions(
            height: 200.h,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
              _initializeCurrentVideo();
            },
          ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.media.length, (index) {
            return Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? AppColors.lightBlueAccent
                    : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}
