import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:jp_lesson/page/signin_page.dart';
import 'package:jp_lesson/page/signup_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: Image.network(
                'https://cdn.dribbble.com/users/2070709/screenshots/4546163/media/657fa0dc101d5fbb33eba4bee3a98782.jpg?resize=800x600&vertical=center',
                fit: BoxFit.cover,
              )),
          // SizedBox(height: 35),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Let get starded!',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('Do it now....!',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                      SizedBox(height: 10),
                      Text(
                          'Explore all the existing job roles based on your interest and study major')
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.off(const SignInPage());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.off(const SignUpPage());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: const Text('Sign Up'))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
