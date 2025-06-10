import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exercise/weightlifting_workout_provider.dart';
import 'package:chewie/chewie.dart';

class WeightliftingWorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeightliftingWorkoutProvider(),
      child: Consumer<WeightliftingWorkoutProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: provider.selectedVideoIndex == null
                        ? Text(
                            "Workout Session",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        : provider.chewieController != null && provider.videoController.value.isInitialized
                            ? Column(
                                children: [
                                  Expanded(child: Chewie(controller: provider.chewieController!)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.skip_previous, size: 36, color: Colors.white),
                                        onPressed: provider.selectedVideoIndex! > 0
                                            ? () => provider.initializePlayer(provider.selectedVideoIndex! - 1)
                                            : null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          provider.videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                        onPressed: provider.togglePlayPause,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          provider.videoController.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                        onPressed: provider.toggleMute,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.skip_next, size: 36, color: Colors.white),
                                        onPressed: provider.selectedVideoIndex! < provider.workouts.length - 1
                                            ? () => provider.initializePlayer(provider.selectedVideoIndex! + 1)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Circuit 1: Legs Toning",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.loop, color: Colors.purple),
                            SizedBox(width: 5),
                            Text("3 sets", style: TextStyle(color: Colors.purple, fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child: ListView.separated(
                            itemCount: provider.workouts.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return _buildWorkoutItem(
                                context,
                                provider.workouts[index]["title"]!,
                                provider.workouts[index]["duration"]!,
                                index,
                                provider,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutItem(BuildContext context, String title, String duration, int index, WeightliftingWorkoutProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.play_circle_fill, color: Colors.purple, size: 40),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(duration, style: TextStyle(fontSize: 14, color: Colors.grey)),
        onTap: () => provider.initializePlayer(index),
      ),
    );
  }
}
