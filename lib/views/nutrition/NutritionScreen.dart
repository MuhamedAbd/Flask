import 'package:flutter/material.dart';
import 'package:lung_life/views/nutrition/SupplementsScreen.dart';
import 'chat_bot.dart'; // Import the chat_bot.dart file
import 'package:lung_life/views/nutrition/UserDetailsInputScreen.dart';

class AnimatedNutritionPage extends StatefulWidget {
  @override
  _AnimatedNutritionPageState createState() => _AnimatedNutritionPageState();
}

class _AnimatedNutritionPageState extends State<AnimatedNutritionPage> with SingleTickerProviderStateMixin {
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  "Nutrition section",
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_colorAnimation1.value!, _colorAnimation2.value!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplementsScreen(),
                              ),
                            );
                          },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Supplements",
                                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Image.asset(
                                'assets/images/supplements.png',
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the UserDetailsInputScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => UserDetailsInputScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 450,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_colorAnimation2.value!, _colorAnimation1.value!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "AI Diet",
                                      style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Assistant",
                                      style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Image.asset(
                                  'assets/images/ai_diet.png',
                                  height: 290,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}