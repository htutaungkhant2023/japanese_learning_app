import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jp_lesson/firebase/auth_helper.dart';

//COLORS
const backgroundColor = Colors.black;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
var currentUser = firebaseAuth.currentUser;

//CONTROLLER
var authController = AuthController.instance;
