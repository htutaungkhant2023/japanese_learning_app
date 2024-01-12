import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jp_lesson/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

var user = FirebaseAuth.instance.currentUser;

class _SignInPageState extends State<SignInPage> {
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPassword = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            height: size.height * 0.2,
            child: const Column(children: [
              Text(
                'Login here',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Welcome back you've ",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Text(
                "been missed!",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ]),
          ),
          Expanded(
            child: SizedBox(
              width: size.width * 0.85,
              // height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: inputEmail,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    controller: inputPassword,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Forgot your password?',
                    style: TextStyle(color: Colors.red.shade400, fontSize: 14),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            isLoading = true;
                            // loginData();
                            authController.loginUser(
                                inputEmail.text, inputPassword.text);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ))),
                  const SizedBox(height: 15),
                  const Text('Create new account? Sign up!'),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('images/google.svg'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('images/facebook.svg'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('images/apple.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
