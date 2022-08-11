import 'package:flutter/material.dart';
import 'package:possystem/constants/fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading   ',style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: mainColor)),
              CircularProgressIndicator(color: mainColor,),
            ],
          )));
  }
}