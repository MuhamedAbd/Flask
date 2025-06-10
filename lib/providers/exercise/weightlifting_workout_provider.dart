import 'package:flutter/material.dart';
import '../../controllers/exercise/weightlifting_workout_controller.dart';

class WeightliftingWorkoutProvider extends ChangeNotifier {
  final WeightliftingWorkoutController controller = WeightliftingWorkoutController();

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