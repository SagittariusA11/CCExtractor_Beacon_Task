import 'dart:async';

import 'package:ccextractor_beacon_task/utils/my_widgets.dart';
import 'package:ccextractor_beacon_task/utils/profile_screen.dart';
import 'package:ccextractor_beacon_task/utils/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:ccextractor_beacon_task/map.dart';

import 'controller/data_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DataController controller = Get.put(DataController());
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

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
    return SafeArea(
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
                          _getLocation();
                        },
                      ),
                      elevatedButton(
                        text: "Share location",
                        onpress: () {
                          _shareLocation();
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
                          _getLocation();
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
                      if (snapshot.hasData) {
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
                        return Container();
                        // return Container(
                        //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        //     padding: const EdgeInsets.all(20.0),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white54.withOpacity(0.5),
                        //       borderRadius: BorderRadius.all(
                        //           Radius.elliptical(25, 25)),
                        //     ),
                        //     child: Center(
                        //       child: FittedBox(
                        //         child: Text(
                        //           'No one has shared\ntheir location yet!',
                        //           textAlign: TextAlign.left,
                        //           style: TextStyle(
                        //               color: Color.fromRGBO(0, 0, 0, 1),
                        //               fontFamily: 'Outfit',
                        //               fontSize: 20,
                        //               letterSpacing:
                        //               0 /*percentages not used in flutter. defaulting to zero*/,
                        //               fontWeight: FontWeight.bold,
                        //               height: 1),
                        //         ),
                        //       ),
                        //     )
                        // );
                      }
                    },
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
  String uid = FirebaseAuth.instance.currentUser!.uid;

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'lat': _locationResult.latitude,
        'long': _locationResult.longitude,
        // 'name': '${controller.dataNotifier['name']}',
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _shareLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'lat': currentlocation.latitude,
        'long': currentlocation.longitude,
        'share': true,
      }, SetOptions(merge: true));
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
}
