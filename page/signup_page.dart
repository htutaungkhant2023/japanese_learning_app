import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jp_lesson/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController inputName = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  TextEditingController inputConfirmPassword = TextEditingController();

  late FirebaseFirestore firestore;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    super.dispose();
    inputName.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
    inputConfirmPassword.dispose();
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
            height: size.height * 0.15,
            child: const Column(children: [
              Text(
                'Create Account',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Create an account so you can explore all the",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "existing jobs!",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ]),
          ),
          Expanded(
            child: SizedBox(
              width: size.width * 0.85,
              // height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: inputName,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    controller: inputConfirmPassword,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (inputPassword.text.toString() !=
                                inputConfirmPassword.text.toString()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Password must be same!')));
                            } else if (inputPassword.text.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Password should be at least 6 number')));
                            } else {
                              authController.registerUser(inputName.text,
                                  inputEmail.text, inputPassword.text);
                              setState(() {
                                isLoading = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ))),
                  const SizedBox(height: 15),
                  const Text('Already have an account? Sign In'),
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
