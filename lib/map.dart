import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import 'home_screen.dart';
import 'main.dart';

class Map extends StatefulWidget {
  final String user_id;
  Map(this.user_id);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (_added) {
                map(snapshot);
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      position: LatLng(
                        snapshot.data!.docs.singleWhere(
                                (element) => element.id == widget.user_id)['lat'],
                        snapshot.data!.docs.singleWhere(
                                (element) => element.id == widget.user_id)['long'],
                      ),
                      markerId: MarkerId('id'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta)),
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['lat'],
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['long'],
                    ),
                    zoom: 14.47),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              );
            },
          )),
    );
  }

  Future<void> map(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['lat'],
          snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['long'],
        ),
        zoom: 14.47)));
  }
  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasBeenPressedTwice = currentTime.difference(backButtonPressTime) > const Duration(seconds: 2) &&
        currentTime.difference(backButtonPressTime) < const Duration(seconds: 5);

    if (backButtonHasBeenPressedTwice) {
      SystemNavigator.pop();
      return false;
    } else {
      backButtonPressTime = currentTime;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
      return false;
    }
  }
}
