import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'comms/chat_comms.dart';
import 'exercise/ExercisePage.dart';
import 'nutrition/NutritionScreen.dart';
import 'advices/advices_screen.dart';
import 'control_panel/ControlPanelScreen.dart';

class WellnessHomePage extends StatefulWidget {
  @override
  _WellnessHomePageState createState() => _WellnessHomePageState();
}

class _WellnessHomePageState extends State<WellnessHomePage> {
  bool _animateColors = false;

  @override
  void initState() {
    super.initState();
    _startColorAnimation();
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).getUserEmail());
  }

  void _startColorAnimation() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _animateColors = !_animateColors;
      });
      _startColorAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF1C1B29),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الترحيب
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF3A1078),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome: ${userProvider.userName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Start Your",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Wellness Journey",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ControlPanelScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Explore",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedCard(
                            title: "Cardio & Breathing exercises",
                            imagePath: 'assets/images/cardio.png',
                            textHeight: 100,
                            width: 170,
                            height: 600,
                            imageHeight: 200,
                            imageWidth: 300,
                            animateColors: _animateColors,
                            onTap: () {
                              _navigateToNewPage(context, "Cardio");
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: AnimatedCard(
                                  title: "Sleep Insights",
                                  imagePath: "assets/images/advices.png",
                                  textHeight: 30,
                                  width: 190,
                                  height: 150,
                                  imageHeight: 100,
                                  imageWidth: 220,
                                  animateColors: _animateColors,
                                  onTap: () {
                                    _navigateToNewPage(context, "Advices");
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: AnimatedCard(
                                  title: "Nutrition and supplements",
                                  imagePath: "assets/images/nutrition.png",
                                  textHeight: 30,
                                  width: 190,
                                  height: 150,
                                  imageHeight: 100,
                                  imageWidth: 220,
                                  animateColors: _animateColors,
                                  onTap: () {
                                    _navigateToNewPage(context, "Nutrition");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: AnimatedChatCard(
                      title: "Patient's Chat",
                      imagePath: "assets/images/chat.png",
                      animateColors: !_animateColors,
                      onTap: () {
                        _navigateToNewPage(context, "Chat");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNewPage(BuildContext context, String pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (pageName) {
            case "Cardio":
              return ExercisePage();
            case "Nutrition":
              return AnimatedNutritionPage();
            case "Chat":
              return ChatScreen();
            case "Advices":
              return const AdvicesScreen();
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double width;
  final double height;
  final double imageHeight;
  final double imageWidth;
  final double textHeight; // التحكم في ارتفاع النص داخل البطاقة
  final bool animateColors;
  final VoidCallback onTap;

  AnimatedCard({
    required this.title,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.imageHeight,
    required this.imageWidth,
    required this.textHeight,
    required this.animateColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: animateColors
                ? [Color(0xFFFFD700), Color(0xFF8B00FF)]
                : [Color(0xFF8B00FF), Color(0xFFFFD700)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: textHeight), // التحكم في ارتفاع النص
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter, // جعل الصورة تبدأ من الأسفل
              child: Image.asset(
                imagePath,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedChatCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool animateColors;
  final VoidCallback onTap;

  AnimatedChatCard({
    required this.title,
    required this.imagePath,
    required this.animateColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: animateColors
                ? [Color(0xFFFFD700), Color(0xFF8B00FF)]
                : [Color(0xFF8B00FF), Color(0xFFFFD700)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
