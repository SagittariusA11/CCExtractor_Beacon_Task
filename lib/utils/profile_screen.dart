import 'package:ccextractor_beacon_task/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/data_controller.dart';
import 'my_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final DataController controller = Get.put(DataController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getUserData();
      setState(() {});
    });
    super.initState();
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
          height: SizeConfig.height*1,
          width: SizeConfig.width*1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.white],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(controller.dataNotifier['imageUrl'].toString()),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.elliptical(150, 150)),
                  )
              ),
              ProfileDetail(
                  'Name',
                  controller.dataNotifier['name'].toString()
              ),
              ProfileDetail(
                  'Mobile Number',
                  controller.dataNotifier['mobileNumber'].toString()
              ),
              ProfileDetail(
                  'Date Of Birth',
                  controller.dataNotifier['dob'].toString()
              ),
              ProfileDetail(
                  'Gender',
                  controller.dataNotifier['gender'].toString()
              ),
            ],
          ),
        ),
      ),
    );
  }

}
