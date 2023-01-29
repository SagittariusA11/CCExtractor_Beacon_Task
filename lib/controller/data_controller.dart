import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'comman_dialog.dart';

class DataController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final firebaseInstance = FirebaseFirestore.instance;
  List<User> userData = [];
  Map dataNotifier = {};

  Future<void> getUserData() async {
    try{
      CommonDialog.showLoading();
      var response = await firebaseInstance
      .collection('user')
      .where('uid', isEqualTo: auth.currentUser!.uid)
      .get();
      if (response.docs.isNotEmpty) {
        final newData = dataNotifier;
        newData['name'] = response.docs[0]['name'];
        newData['gender'] = response.docs[0]['gender'];
        newData['dob'] = response.docs[0]['dob'];
        newData['imageUrl'] = response.docs[0]['image'];
        newData['mobileNumber'] = response.docs[0]['mobileNumber'];
        dataNotifier = newData;
      }
      debugPrint(dataNotifier.toString());
      CommonDialog.hideLoading();
    } on FirebaseException catch (e) {
      CommonDialog.hideLoading();
      CommonDialog.showErrorDialog();
      print(e);
    } catch (error) {
      CommonDialog.hideLoading();
      CommonDialog.showErrorDialog();
      print(error);
    }
  }
}