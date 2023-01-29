import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart' as Path;

import '../home_screen.dart';


class AuthController extends GetxController{

  FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  void login({String? email, String? password}){
    isLoading(true);
    auth.signInWithEmailAndPassword(
        email: email!,
        password: password!).then((value) {
      isLoading(false);
      Get.to(()=> HomeScreen());
    }).catchError((e){
      print("Error in login $e");
      isLoading(false);
    });
  }

  void signUp({String? email, String? password}){
    isLoading(true);
    auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!).then((value) {
      isLoading(false);
      Get.to(() => const HomeScreen());
    }).catchError((e){
      print("Error in authentication $e");
      isLoading(false);
    });
  }

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      print("Error in sending password reset email is $e");
    });
  }

  var isProfileInformationLoading = false.obs;

  uploadProfileData(String imageUrl, String firstName,
      String mobileNumber, String dob, String age, String shortDetails,
      String Charges , String longDetails, String gender , String uid, String work) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('counsellor_anonymous').doc(uid).set({
      'image': imageUrl,
      'first': firstName,
      'dob': dob,
      'work': work,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'uid': uid,
      'age': age,
      'shortDetails': shortDetails,
      'longDetails': longDetails,
      'charges': Charges
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> HomeScreen());
    });

  }
}