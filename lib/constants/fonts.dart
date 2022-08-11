import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//color
//Color mainColor = const Color.fromRGBO(255, 204, 0, 1);
Color mainColor =  Color.fromRGBO(102, 2, 118, 1); // Color.fromRGBO(	179, 180, 248, 1);
Color button=const Color.fromRGBO(53, 150, 247,1);
Color secondary= const  Color.fromRGBO(235, 113, 2, 1); //Color.fromRGBO(238, 49, 88,1);
Color maind=const Color.fromRGBO(
112, 71, 238,1
);
// ignore: constant_identifier_names
const String BASE_URL = 'https://bogasuperfoods.alsmartaem.com';


//Style
var headerStyle = TextStyle(fontFamily: "Poppins", fontSize: 28.sp,
 fontWeight: FontWeight.bold);
  final buttonStyle = TextStyle(fontFamily: "Poppins", fontSize: 14.sp, fontWeight: FontWeight.bold,color: Colors.white);
 final billStyle = TextStyle(fontFamily: "Poppins", fontSize: 13.sp, fontWeight: FontWeight.bold);
final titleStyle = TextStyle(fontFamily: "Poppins", fontSize: 15.sp, fontWeight: FontWeight.bold,);
final foodcardtitleStyle = TextStyle(fontFamily: "Poppins", fontSize: 15.sp, fontWeight: FontWeight.bold,color: Colors.white);
final titleStyle1 = TextStyle(fontFamily: "Poppins", fontSize: 14.sp, fontWeight: FontWeight.w800,color: Colors.deepPurple);
final titleStyle2 = TextStyle(fontFamily: "Poppins", fontSize: 16.sp, color: Colors.black45);
final subtitleStyle = TextStyle(fontFamily: "Poppins", fontSize: 14.sp, fontWeight: FontWeight.w700);
final infoStyle = TextStyle(fontFamily: "Poppins", fontSize: 14.sp,color: Colors.white70 );//color: Colors.black87);
final titleStyle3=TextStyle(fontFamily: "Poppins", fontSize: 12.sp, fontWeight: FontWeight.w800,color: Colors.blueGrey);
final titleStyle4=TextStyle(fontFamily: "Poppins", fontSize: 11.sp, fontWeight: FontWeight.w800,color: Colors.blueGrey);
//Decoration
final roundedRectangle12 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(12.r),
);

final roundedRectangle4 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(4.r),
);

final roundedRectangle40 = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
);