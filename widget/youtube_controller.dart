import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget(
      {super.key,
      required this.videoUrl,
      this.videoAspectRatio,
      required this.videoController});
  final videoUrl;
  final videoAspectRatio;
  final videoController;

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _playerController;
  bool playState = true;
  @override
  void initState() {
    super.initState();
    _playerController = YoutubePlayerController(
        initialVideoId: widget.videoUrl,
        flags: YoutubePlayerFlags(
            autoPlay: widget.videoController,
            mute: false,
            loop: widget.videoController,
            hideControls: widget.videoController))
      ..addListener(() {
        _onPlayerStateChange();
      });
  }

  void _onPlayerStateChange() {
    if (_playerController.value.playerState == PlayerState.playing) {}
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _playerController.value.isPlaying
          ? _playerController.pause()
          : _playerController.play(),
      child: YoutubePlayer(
        controller: _playerController,
        aspectRatio: widget.videoAspectRatio,
      ),
    );
  }
}
