import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jp_lesson/constants.dart';
import 'package:jp_lesson/model/user.dart' as model;
import 'package:jp_lesson/page/home_page.dart';
import 'package:jp_lesson/page/registration_page.dart';
import 'package:jp_lesson/page/signin_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(const RegistrationPage());
    } else {
      Get.offAll(const MyHomePage());
    }
  }

  void registerUser(String username, String email, String password) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // Upload data to firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        model.User user = model.User(
            name: username, email: email, uid: cred.user!.uid, url: '');
        await firestore
            .collection('Users')
            .doc(email)
            .set(user.toMap())
            .then((value) => Get.off(const MyHomePage()));
      } else {
        Get.snackbar('Error Creating Account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Get.off(const MyHomePage()));
      } else {
        Get.snackbar('Error logging in ', 'Plese enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  void logoutUser() {
    firebaseAuth.signOut().then((value) => Get.offAll(const SignInPage()));
  }
}
