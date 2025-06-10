import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/wrapper.dart';
import 'providers/user_provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
       '/': (context) => SplashScreen(), // شاشة البداية
        '/login': (context) =>  Wrapper(), // صفحة تسجيل الدخول
      },
    );
  }
}
