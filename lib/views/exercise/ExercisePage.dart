import 'package:flutter/material.dart';
import 'breathing.dart';
import 'cardio.dart';
import 'weight_lifting.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Color(0xFFFFD700),
      end: Color(0xFF8B00FF),
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Color(0xFF8B00FF),
      end: Color(0xFFFFD700),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1B29),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
              child: Text(
                "All the exercises you need",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedExerciseCard(
                  imagePath: 'assets/images/BreathingExercise.png',
                  title: "Breathing Exercises",
                  animation1: _colorAnimation1,
                  animation2: _colorAnimation2,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreathingWorkoutScreen()),
                  ),
                ),
                AnimatedExerciseCard(
                  imagePath: 'assets/images/cardio.png',
                  title: "Cardio Exercises",
                  animation1: _colorAnimation2,
                  animation2: _colorAnimation1,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardioWorkoutScreen()),
                  ),
                ),
                AnimatedExerciseCard(
                  imagePath: 'assets/images/Weight Lifting.png',
                  title: "Weight Lifting",
                  animation1: _colorAnimation1,
                  animation2: _colorAnimation2,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeightliftingWorkoutScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedExerciseCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final Animation<Color?> animation1;
  final Animation<Color?> animation2;
  final VoidCallback onTap;

  const AnimatedExerciseCard({
    required this.imagePath,
    required this.title,
    required this.animation1,
    required this.animation2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation1,
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            height: 235,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [animation1.value!, animation2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    imagePath,
                    height: 300,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BreathingExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Breathing Exercises")),
      body: Center(child: Text("Breathing Exercise Details")),
    );
  }
}

class CardioExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cardio Exercises")),
      body: Center(child: Text("Cardio Exercise Details")),
    );
  }
}

class WeightLiftingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weight Lifting")),
      body: Center(child: Text("Weight Lifting Exercise Details")),
    );
  }
}