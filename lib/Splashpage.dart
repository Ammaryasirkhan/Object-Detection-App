import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project5/main.dart';
import 'CAMERA.dart';
import 'bottom nav page/profilepage.dart';
import 'cam.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
      MaterialPageRoute(builder: (context) =>  /*CAMERA(title: 'CMARA')*/ MyHomePage(title: 'homepage')
      ));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child:Image.asset('assets/images/sp.jpg',),
        ),
      ),
    );
  }}
