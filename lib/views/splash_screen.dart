import 'package:flutter/material.dart';
import 'dart:math';
import '../services/wrapper.dart'; // تأكد من استيراد ملف الـ Wrapper

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    // التأخير للانتقال إلى Wrapper بعد 3 ثوانٍ
    Future.delayed(Duration(seconds: 3), () {
      // التنقل إلى شاشة Wrapper بعد الـ Splash Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()), // تأكد من أن Wrapper موجود في المسار الصحيح
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الدوائر المتحركة
          ..._buildAnimatedCircles(),

          Center(
            child: Image.asset(
              'assets/images/dr.png', // تأكد من أن الصورة موجودة في المجلد الصحيح
              width: 500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedCircles() {
    return [
      _buildAnimatedCircle(60, 50, 50, 0, Alignment.topLeft),
      _buildAnimatedCircle(-100, 120, 120, pi / 2, Alignment.topRight),
      _buildAnimatedCircle(300, 90, 90, pi, Alignment.centerLeft),
      _buildAnimatedCircle(240, 40, 40, 3 * pi / 2, Alignment.centerRight),
      _buildStaticCircle(-150, 200, Alignment.bottomLeft),
    ];
  }

  Widget _buildAnimatedCircle(double offset, double radius, double size, double phase, Alignment alignment) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: alignment.y == Alignment.bottomLeft.y ? null : offset + 20 * sin(_controller.value * 2 * pi + phase),
          bottom: alignment.y == Alignment.bottomLeft.y ? offset : null,
          left: alignment.x == Alignment.bottomLeft.x ? offset : null,
          right: alignment.x == Alignment.topRight.x ? offset : null,
          child: CircleAvatar(
            radius: size,
            backgroundColor: Color(0xFF5B2D50),
          ),
        );
      },
    );
  }

  Widget _buildStaticCircle(double offset, double size, Alignment alignment) {
    return Positioned(
      bottom: alignment == Alignment.bottomLeft ? offset : null,
      left: alignment == Alignment.bottomLeft ? offset : null,
      right: alignment == Alignment.bottomRight ? offset : null,
      child: CircleAvatar(
        radius: size,
        backgroundColor: Color(0xFF5B2D50),
      ),
    );
  }
}
