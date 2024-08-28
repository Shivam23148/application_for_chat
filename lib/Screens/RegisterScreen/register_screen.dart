import 'package:chat_application/Blocs/AuthBloc/auth_bloc.dart';
import 'package:chat_application/Blocs/AuthBloc/auth_event.dart';
import 'package:chat_application/Blocs/AuthBloc/auth_state.dart';
import 'package:chat_application/Screens/HomeScreen/home_screen.dart';
import 'package:chat_application/Screens/LoginScreen/login_screen.dart';
import 'package:chat_application/Services/auth/auth_service.dart';
import 'package:chat_application/Widget/my_button.dart';
import 'package:chat_application/Widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  late AuthBloc authBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authBloc = AuthBloc(AuthService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: BlocListener(
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
          child: SingleChildScrollView(
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
                Text("Let's create an account for you",
                    style:
                        TextStyle(fontSize: 17, color: Colors.grey.shade500)),
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
                //confirm textfield
                MyTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    textEditingController: _confirmpasswordController),
                SizedBox(
                  height: 15,
                ),
                //login button
                MyButton(
                    onPressed: () {
                      if (_passwordController.text ==
                          _confirmpasswordController.text) {
                        print("Passwords are same");
                        authBloc.add(AuthSignUpRequested(
                            email: _emailController.text,
                            password: _passwordController.text));
                      }
                    },
                    text: "Register"),
                SizedBox(
                  height: 15,
                ),
                //register now button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Login now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
