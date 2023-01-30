import 'dart:async';

import 'package:ccextractor_beacon_task/utils/my_widgets.dart';
import 'package:ccextractor_beacon_task/utils/profile_screen.dart';
import 'package:ccextractor_beacon_task/utils/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:ccextractor_beacon_task/map.dart';

import 'controller/data_controller.dart';
import 'login_view.dart';
import 'main.dart';

DateTime shareButtonPressTime = DateTime.now();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DataController controller = Get.put(DataController());
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  TextEditingController textBox = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getUserData();
      setState(() {});
    });
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('CCExtractor_Beacon_Task'),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: FittedBox(
                        child: Text(
                          'Hey, ${controller.dataNotifier['name']}!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        elevatedButton(
                          text: "Update location",
                          onpress: () {
                            _getLocation('updated');
                          },
                        ),
                        elevatedButton(
                          text: "Share location",
                          onpress: () {
                            showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: Container(
                                    width: SizeConfig.width*0.75,
                                    height: SizeConfig.height*0.31,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 4.0,
                                            spreadRadius: 3.0,
                                            offset: const Offset(4, 4)
                                        )]
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => Navigator.of(context).pop(),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: const AssetImage('assets/cancel.png'),
                                                        fit: BoxFit.cover
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Share until',
                                          style: GoogleFonts.comicNeue(
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Material(
                                            color: Colors.transparent,
                                            shape: const StadiumBorder(
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: TextField(
                                              controller: textBox,
                                              keyboardType: TextInputType.emailAddress,
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                              decoration: InputDecoration(
                                                  border: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  ),
                                                  hintText: 'How many hours?',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey.shade500,
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: TextButton(
                                                  child: Container(
                                                    width: SizeConfig.height*0.14,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black
                                                      ),
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      // boxShadow: [BoxShadow(
                                                      //     color: Colors.black.withOpacity(0.3),
                                                      //     blurRadius: 4.0,
                                                      //     spreadRadius: 3.0,
                                                      //     offset: Offset(4, 4)
                                                      // )]
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          'Share',
                                                          style: GoogleFonts.catamaran(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    _shareLocation(int.parse(textBox.text));
                                                    Navigator.pop(context);
                                                  }
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            );
                            // _shareLocation();
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        elevatedButton(
                          text: "Stop Sharing",
                          onpress: () {
                            _stopSharing();
                          },
                        ),
                        elevatedButton(
                          text: "My Profile",
                          onpress: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
                StreamBuilder(
                  stream:
                  FirebaseFirestore.instance.collection('user')
                      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data?.docs[0]['lat'] != '') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100.withOpacity(0.5),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)
                              )
                            ),
                            child: Text(
                              'My Saved Location',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Outfit',
                                  fontSize: 20,
                                  letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ),
                          ),
                          Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white54.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(25, 25)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data!.docs[0]['image'].toString()),
                                            fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(65, 65)),
                                        )
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[0]['name'].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontFamily: 'Outfit',
                                              fontSize: 20,
                                              letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Latitude: ${snapshot.data!.docs[0]['lat'].toString()}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(0, 0, 0, 1),
                                                      fontFamily: 'Outfit',
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                  'Longitude: ${snapshot.data!.docs[0]['long'].toString()}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(0, 0, 0, 1),
                                                      fontFamily: 'Outfit',
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(Icons.directions),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        Map(snapshot.data!.docs[0].id)));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      );
                    }
                    else {
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade100.withOpacity(0.5),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)
                              )
                          ),
                          child: Text(
                            'My Saved Location',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _getLocation('added');
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white54.withOpacity(0.5),
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(25, 25)),
                            ),
                            child: Center(
                              child: Text(
                                'Tap to Add Location',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Outfit',
                                    fontSize: 20,
                                    letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              ),
                            )
                          ),
                        ),
                      ],
                    );
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0)
                      )
                  ),
                  child: Text(
                    'Shared Location',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                ),
                Expanded(
                    child: StreamBuilder(
                      stream:
                      FirebaseFirestore.instance.collection('user')
                          .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data?.docs[0]['share']) {
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data?.docs[index]['share']) {
                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white54.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(25, 25)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot.data!.docs[index]['image'].toString()),
                                                  fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(65, 65)),
                                            )
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]['name'].toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                  fontFamily: 'Outfit',
                                                  fontSize: 20,
                                                  letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Latitude: ${snapshot.data!.docs[index]['lat'].toString()}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(0, 0, 0, 1),
                                                          fontFamily: 'Outfit',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      'Longitude: ${snapshot.data!.docs[index]['long'].toString()}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(0, 0, 0, 1),
                                                          fontFamily: 'Outfit',
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(Icons.directions),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            Map(snapshot.data!.docs[index].id)));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return Container();
                                }
                              },
                          );
                        }
                        else {
                          // return Container();
                          return Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.white54.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(25, 25)),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    'No one has shared\ntheir location yet!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Outfit',
                                        fontSize: 20,
                                        letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  ),
                                ),
                              )
                          );
                        }
                      },
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  String uid = FirebaseAuth.instance.currentUser!.uid;

  _getLocation(String text) async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'lat': _locationResult.latitude,
        'long': _locationResult.longitude,
        // 'name': '${controller.dataNotifier['name']}',
      }, SetOptions(merge: true));
      Fluttertoast.showToast(
          msg: "Location has been $text",
          backgroundColor: Colors.black,
          textColor: Colors.white);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _shareLocation(int time) async {
    Fluttertoast.showToast(
        msg: "Sharing has started",
        backgroundColor: Colors.black,
        textColor: Colors.white);
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      DateTime currentTime = DateTime.now();
      bool shareButtonPressedHasBeen = currentTime.difference(shareButtonPressTime) > const Duration(seconds: 0) &&
          currentTime.difference(shareButtonPressTime) < Duration(seconds: time*3600);
      if (shareButtonPressedHasBeen) {
        // shareButtonPressTime = currentTime;
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          'lat': currentlocation.latitude,
          'long': currentlocation.longitude,
          'share': true,
        }, SetOptions(merge: true));
        // print("share $currentTime");
      }
      else {
        shareButtonPressTime = currentTime;
        _stopSharing();
        // print("stop $currentTime");
      }
    });
  }

  _stopSharing() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      'share': false,
    }, SetOptions(merge: true));
    Fluttertoast.showToast(
        msg: "Sharing has stopped",
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButtonHasBeenPressedTwice = currentTime.difference(backButtonPressTime) > const Duration(seconds: 2) &&
        currentTime.difference(backButtonPressTime) < const Duration(seconds: 5);

    if (backButtonHasBeenPressedTwice) {
      backButtonPressTime = currentTime;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginView()));
      return false;
    } else {
      Fluttertoast.showToast(
          msg: "Press again to Logout",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
  }
}
