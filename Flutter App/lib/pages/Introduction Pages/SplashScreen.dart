import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/main.dart';
import 'package:driver_behaviour_gp/pages/Introduction%20Pages/IntroductionPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashScreen({super.key, required this.cameras});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>IntroductioPage(cameras: cameras!,)));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/Images/SplashLogo.png',
                  height: 150,
                ),
                SizedBox(height: 20,),
                Text("Drive Safely",style: TextStyle(fontFamily: "font1",fontSize: 22),)
              ],
            ),
            CircularProgressIndicator(color: Colors.grey,),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
