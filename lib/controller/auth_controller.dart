import 'dart:io';
import 'package:ccextractor_beacon_task/add_profile.dart';
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
      Get.to(() => const AddProfileScreen());
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

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);

    var reference =
    FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      print("Error happen $e");
    });

    return imageUrl;
  }




  uploadProfileData(String imageUrl, String name,
      String mobileNumber, String dob,
      String gender , String uid) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('user').doc(uid).set({
      'image': imageUrl,
      'name': name,
      'dob': dob,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'uid': uid,
    }).then((value) {
      isProfileInformationLoading(false);
      Get.offAll(()=> HomeScreen());
    });

  }

}