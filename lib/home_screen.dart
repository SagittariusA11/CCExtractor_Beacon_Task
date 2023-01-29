import 'dart:async';

import 'package:ccextractor_beacon_task/utils/my_widgets.dart';
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
                        text: "Add location",
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
                        text: "Stop Sharing",
                        onpress: () {},
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder(
                    stream:
                    FirebaseFirestore.instance.collection('location').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                              Text(snapshot.data!.docs[index]['name'].toString()),
                              subtitle: Row(
                                children: [
                                  Text(snapshot.data!.docs[index]['latitude']
                                      .toString()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(snapshot.data!.docs[index]['longitude']
                                      .toString()),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Map(snapshot.data!.docs[index].id)));
                                },
                              ),
                            );
                          });
                    },
                  )),
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
      await FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': '${controller.dataNotifier['name']}',
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
      await FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  _stopSharing() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
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
