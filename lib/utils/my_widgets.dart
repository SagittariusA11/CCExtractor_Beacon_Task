import 'package:ccextractor_beacon_task/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen.dart';
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
        margin: const EdgeInsets.symmetric(horizontal: 20),
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

Widget DialogBox(
    BuildContext context,
    Function onPressed,
    ) {
  TextEditingController textBox = TextEditingController();
  return Center(
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
                      onPressed(textBox.text);
                    }
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}