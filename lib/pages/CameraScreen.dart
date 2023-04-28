import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;


class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({Key? key,required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  CameraController? _controller;
  int _timer = 3;
  Timer ?_photoTimer;
  Completer<void> ?_previousCaptureCompleter;
  File? selectedImage;
  String? message = "";

  uploadImage() async{
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://d034-102-188-141-35.eu.ngrok.io/upload"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resjason = jsonDecode(res.body);
    message = resjason['message'];
    print("################################################################## $message");
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = CameraController(widget.cameras ![0], ResolutionPreset.medium);
    _controller!.setFlashMode(FlashMode.off);
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    _photoTimer?.cancel();
    super.dispose();
  }
  Future<void> _takePicture() async {
    await _previousCaptureCompleter?.future;

    // Create a Completer to track the current capture
    final Completer<void> completer = Completer();
    _previousCaptureCompleter = completer;
    try {
      // Ensure that the camera is initialized.
      await _controller!.initialize();

      // Take the picture.
      final XFile file = await _controller!.takePicture();
      selectedImage = File(file.path);
      // Save the picture to the device's gallery.
      //final result = await ImageGallerySaver.saveFile(file.path);
      //print('Picture saved to gallery: $result');
      setState(() {

      });
      uploadImage();
      completer.complete();

    } catch (e) {
      print('Error taking picture: $e');
    }
  }
  void _startTimer() async{
    _photoTimer = Timer.periodic(Duration(seconds: _timer), (timer) {
      _takePicture();
    });
  }

  void _stopTimer() {
    _photoTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 300,
              child: CameraPreview(_controller!),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('Stop'),
                ),
              ],
            ),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: message),
              style: TextStyle(color: Colors.pink,fontSize: 16,fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}



// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:provider/provider.dart';
// //
// // import '../main.dart';
// //
// //
// // class CameraScreen extends StatefulWidget {
// //   const CameraScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<CameraScreen> createState() => _CameraScreenState();
// // }
// //
// // class _CameraScreenState extends State<CameraScreen> {
// //   CameraController? _controller;
// //   int _timer = 2;
// //   Timer ?_photoTimer;
// //   Completer<void> ?_previousCaptureCompleter;
// //   File? selectedImage;
// //   String? message = "";
// //
// //   uploadImage() async{
// //     final request = http.MultipartRequest(
// //         "POST", Uri.parse("https://8b74-102-188-141-35.eu.ngrok.io/upload"));
// //     final headers = {"Content-type": "multipart/form-data"};
// //     request.files.add(http.MultipartFile('image',
// //         selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
// //         filename: selectedImage!.path.split("/").last));
// //     request.headers.addAll(headers);
// //     final response = await request.send();
// //     http.Response res = await http.Response.fromStream(response);
// //     final resjason = jsonDecode(res.body);
// //     message = resjason['message'];
// //     setState(() {});
// //   }
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = CameraController(cameras![0], ResolutionPreset.medium);
// //     _controller!.initialize().then((_) {
// //       if (!mounted) {
// //         return;
// //       }
// //       setState(() {});
// //     });
// //   }
// //   @override
// //   void dispose() {
// //     _controller!.dispose();
// //     _photoTimer?.cancel();
// //     super.dispose();
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     List<CameraDescription>? cameras = Provider.of<CamerasProvider>(context).cameras;
// //     return Placeholder();
// //
// //   }
// // }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:camera/camera.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:http/http.dart' as http;
// List<CameraDescription> ?cameras;
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Camera Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   CameraController? _controller;
//   int _timer = 2;
//   Timer ?_photoTimer;
//   Completer<void> ?_previousCaptureCompleter;
//   File? selectedImage;
//   String? message = "";
//
//   uploadImage() async{
//     final request = http.MultipartRequest(
//         "POST", Uri.parse("https://e364-102-188-141-35.eu.ngrok.io/upload"));
//     final headers = {"Content-type": "multipart/form-data"};
//     request.files.add(http.MultipartFile('image',
//         selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
//         filename: selectedImage!.path.split("/").last));
//     request.headers.addAll(headers);
//     final response = await request.send();
//     http.Response res = await http.Response.fromStream(response);
//     final resjason = jsonDecode(res.body);
//     message = resjason['message'];
//     setState(() {});
//   }
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(cameras![0], ResolutionPreset.medium);
//     _controller!.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller!.dispose();
//     _photoTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _takePicture() async {
//     await _previousCaptureCompleter?.future;
//
//     // Create a Completer to track the current capture
//     final Completer<void> completer = Completer();
//     _previousCaptureCompleter = completer;
//     try {
//       // Ensure that the camera is initialized.
//       await _controller!.initialize();
//
//       // Take the picture.
//       final XFile file = await _controller!.takePicture();
//       selectedImage = File(file.path);
//       // Save the picture to the device's gallery.
//       //final result = await ImageGallerySaver.saveFile(file.path);
//       //print('Picture saved to gallery: $result');
//       setState(() {
//
//       });
//       uploadImage();
//       completer.complete();
//
//     } catch (e) {
//       print('Error taking picture: $e');
//     }
//   }
//   void _startTimer() async{
//     _photoTimer = Timer.periodic(Duration(seconds: _timer), (timer) {
//       _takePicture();
//     });
//   }
//
//   void _stopTimer() {
//     _photoTimer?.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_controller!.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 200,
//               width: 300,
//               child: CameraPreview(_controller!),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _startTimer,
//                   child: Text('Start'),
//                 ),
//                 ElevatedButton(
//                   onPressed: _stopTimer,
//                   child: Text('Stop'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // Future<void> takePicture(CameraController cameraController, String filePath) async {
// //   try {
// //     // Ensure that the camera is initialized.
// //     await cameraController.initialize();
// //
// //     // Take the picture.
// //     final XFile file = await cameraController.takePicture();
// //
// //     // Save the picture to the specified file path.
// //     final File pictureFile = File(file.path);
// //     await pictureFile.copy(filePath);
// //   } catch (e) {
// //     print('Error taking picture: $e');
// //   }
// // }
