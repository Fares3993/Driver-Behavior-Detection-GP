import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/videoPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
List<CameraDescription> ?cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/videoPage':(context)=>VideoPage()
      },
      home: Home(cameras: cameras!,),
    );
  }
}
