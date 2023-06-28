import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/Introduction%20Pages/SplashScreen.dart';
import 'package:driver_behaviour_gp/pages/videoPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class StringData extends ChangeNotifier {
  String _email = '';
  String _alert = '';

  String get email => _email;
  String get alert => _alert;

  void updateEmail(String newEmail) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _email = newEmail;
      notifyListeners();
    });
  }
  void updateAlert(String newAlert) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _alert = newAlert;
      notifyListeners();
    });
  }
}
List<CameraDescription> ?cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  return runApp(ChangeNotifierProvider(
    create: (context) => StringData(),
    child: MyApp(),
  ),);
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
      home: SplashScreen(cameras: cameras!,),
    );
  }
}
