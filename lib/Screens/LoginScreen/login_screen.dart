import 'package:chat_application/Blocs/AuthBloc/auth_bloc.dart';
import 'package:chat_application/Blocs/AuthBloc/auth_event.dart';
import 'package:chat_application/Blocs/AuthBloc/auth_state.dart';
import 'package:chat_application/Screens/HomeScreen/home_screen.dart';
import 'package:chat_application/Screens/RegisterScreen/register_screen.dart';
import 'package:chat_application/Services/auth/auth_service.dart';
import 'package:chat_application/Widget/my_button.dart';
import 'package:chat_application/Widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AuthBloc authBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authBloc = AuthBloc(AuthService());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    authBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                barrierColor: Colors.white,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            authBloc: authBloc,
                          )));
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.message_sharp,
                size: MediaQuery.sizeOf(context).height * 0.1,
                color: Colors.grey.shade500,
              ),
              SizedBox(
                height: 20,
              ),
              //welcome back
              Text("Welcome back, you've been missed!",
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade500)),
              SizedBox(
                height: 20,
              ),
              //email textfield
              MyTextField(
                hintText: "Email",
                textEditingController: _emailController,
              ),
              SizedBox(
                height: 10,
              ),
              //password textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                textEditingController: _passwordController,
              ),
              SizedBox(
                height: 15,
              ),
              //login button
              MyButton(
                  onPressed: () {
                    authBloc.add(AuthSignInRequested(
                        email: _emailController.text,
                        password: _passwordController.text));
                  },
                  text: "Login"),
              SizedBox(
                height: 15,
              ),
              //register now button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? "),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text("Register now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
