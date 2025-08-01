import 'package:video_player/video_player.dart';

class MediaItem {
  final String type; // 'image' or 'video'
  final String url;
  Duration? _videoDuration;

  MediaItem({required this.type, required this.url});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      type: json['type'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'url': url,
      };

  Future<Duration?> getVideoDuration() async {
    if (type != 'video') return null;

    if (_videoDuration != null) return _videoDuration;

    try {
      final controller = VideoPlayerController.asset('assets/videos/$url');
      await controller.initialize();
      _videoDuration = controller.value.duration;
      await controller.dispose();
      return _videoDuration;
    } catch (e) {
      print('Error getting video duration: $e');
      return null;
    }
  }

  bool get isVideo => type == 'video';
}
