import 'package:chat_application/Screens/HomeScreen/home_screen.dart';
import 'package:chat_application/Screens/LoginScreen/login_screen.dart';
import 'package:chat_application/Screens/RegisterScreen/register_screen.dart';
import 'package:chat_application/Screens/SplashScreen/splash_screen.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: SplashScreen());
  }
}
