import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/videoPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CamerasProvider extends ChangeNotifier {
  List<CameraDescription>? _cameras;

  List<CameraDescription>? get cameras => _cameras;

  set cameras(List<CameraDescription>? cameras) {
    _cameras = cameras;
    notifyListeners();
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CamerasProvider camerasProvider = CamerasProvider();
  camerasProvider.cameras = await availableCameras();
  return runApp(ChangeNotifierProvider.value(
    value: camerasProvider,
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
      home: Home(),
    );
  }
}
