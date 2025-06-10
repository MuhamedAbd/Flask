import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class BreathingWorkoutController {
  final List<Map<String, String>> workouts = [
    {
      "title": "Diaphragmatic Breathing (Sitting)",
      "duration": "5 minutes",
      "videoPath": "assets/videos/breathing/Diaphragmatic-breathing.mp4"
    }
  ];

  int? selectedVideoIndex;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  void initializePlayer(int index, VoidCallback onUpdate) {
    disposePlayer();
    videoController = VideoPlayerController.asset(workouts[index]["videoPath"]!);
    videoController!.initialize().then((_) {
      selectedVideoIndex = index;
      chewieController = ChewieController(
        videoPlayerController: videoController!,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
      );
      onUpdate();
    });
  }

  void togglePlayPause(VoidCallback onUpdate) {
    if (videoController != null) {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
      onUpdate();
    }
  }

  void toggleMute(VoidCallback onUpdate) {
    if (videoController != null) {
      videoController!.setVolume(videoController!.value.volume == 0 ? 1.0 : 0.0);
      onUpdate();
    }
  }

  void disposePlayer() {
    videoController?.dispose();
    chewieController?.dispose();
    videoController = null;
    chewieController = null;
    selectedVideoIndex = null;
  }

  void dispose() {
    disposePlayer();
  }
} 