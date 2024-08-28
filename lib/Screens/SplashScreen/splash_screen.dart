import 'package:chat_application/Blocs/AuthBloc/auth_bloc.dart';
import 'package:chat_application/Screens/HomeScreen/home_screen.dart';
import 'package:chat_application/Screens/LoginScreen/login_screen.dart';
import 'package:chat_application/Services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthBloc authBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authBloc = AuthBloc(AuthService());
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    await Future.delayed(Duration(seconds: 2));
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // User is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    authBloc: authBloc,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: LottieBuilder.asset(
            "assets/Splash/Splash_Animation.json",
            animate: true,
          ),
        ));
  }
}
