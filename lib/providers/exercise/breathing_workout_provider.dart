import 'package:flutter/material.dart';
import '../../controllers/exercise/breathing_workout_controller.dart';

class BreathingWorkoutProvider extends ChangeNotifier {
  final BreathingWorkoutController controller = BreathingWorkoutController();

  List<Map<String, String>> get workouts => controller.workouts;
  int? get selectedVideoIndex => controller.selectedVideoIndex;
  get videoController => controller.videoController;
  get chewieController => controller.chewieController;

  void initializePlayer(int index) {
    controller.initializePlayer(index, notifyListeners);
  }

  void togglePlayPause() {
    controller.togglePlayPause(notifyListeners);
  }

  void toggleMute() {
    controller.toggleMute(notifyListeners);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
} 