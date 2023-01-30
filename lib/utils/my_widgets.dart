import 'package:ccextractor_beacon_task/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'app_color.dart';

Widget myText({text, style, textAlign}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

Widget textField({text,TextEditingController? controller,Function? validator,TextInputType inputType = TextInputType.text}) {
  return Container(
    height: 48,
    margin: EdgeInsets.only(bottom: Get.height * 0.02),
    child: TextFormField(
      keyboardType: inputType,
      controller: controller,
      validator: (input)=> validator!(input),
      decoration: InputDecoration(
          hintText: text,
          errorStyle: TextStyle(fontSize: 0),
          contentPadding: EdgeInsets.only(top: 10, left: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget myTextFieldPassword({text, String? prefixicon, String? suffixicon, bool, TextEditingController? controller,Function? validator}) {
  return Container(
    height: 45,
    child: TextFormField(
      validator: (input)=> validator!(input),
      obscureText: bool,
      controller: controller,
      decoration: InputDecoration(
          contentPadding:EdgeInsets.only(top: 5),
          errorStyle: TextStyle(fontSize: 0),
          hintStyle: TextStyle(
            color: AppColors.genderTextColor,
          ),
          hintText: text,
          prefixIcon: Image.asset(
            prefixicon!,
            cacheHeight: 20,
          ),
          suffixIcon: IconButton(
              onPressed: (){
                bool = !bool;
              },
              icon: Image.asset(
                  suffixicon!,
                  cacheHeight: 20,
              )),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))
      ),
    ),
  );
}

Widget myTextFieldEmail({text, bool, TextEditingController? controller,Function? validator, String? prefixicon}) {
  return Container(
    height: 45,
    child: TextFormField(

      validator: (input)=> validator!(input),
      obscureText: bool,
      controller: controller,
      decoration: InputDecoration(
          contentPadding:EdgeInsets.only(top: 5),
          errorStyle: TextStyle(fontSize: 0),
          hintStyle: TextStyle(
            color: AppColors.genderTextColor,
          ),
          hintText: text,
          prefixIcon: Image.asset(
            prefixicon!,
            cacheHeight: 20,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))
      ),
    ),
  );
}

Widget socialAppsIcons({text,Function? onPressed}) {
  return InkWell(
    onTap: ()=> onPressed!(),
    child: Container(
      margin: EdgeInsets.all(10),
      width: 48,
      height: 48,
      decoration: BoxDecoration(

        image: DecorationImage(
          image: AssetImage(text),
        ),
      ),
    ),
  );
}

Widget elevatedButton({text, Function? onpress}) {
  return ElevatedButton(
    style: ButtonStyle(

      backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
    ),
    onPressed: () {
      onpress!();
    },
    child: Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget ProfileDetail (String field, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: SizeConfig.width*0.8,
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
          field,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Outfit',
              fontSize: 15,
              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
              height: 1),
        ),
      ),
      Container(
        width: SizeConfig.width*0.8,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        decoration: BoxDecoration(
          color: Colors.white54.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0)
            )
        ),
        child: Text(
          value,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Outfit',
              fontSize: 25,
              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
              height: 1),
        ),
      ),
    ],
  );
}