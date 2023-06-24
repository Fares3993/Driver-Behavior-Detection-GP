import 'package:driver_behaviour_gp/pages/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:provider/provider.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

Future<List<dynamic>> getContactEmail(String userEmail) async {
  final contactsEmail = <dynamic>[];
  final userService = UserService1();

  // Get the user based on email
  final user = await userService.getUserByEmail(userEmail);

  if (user != null) {
    contactsEmail.add(user.contactEmail);
    if(user.contactEmail1 != null)
      {
        contactsEmail.add(user.contactEmail1);
      }
    if(user.contactEmail2 != null)
    {
      contactsEmail.add(user.contactEmail2);
    }
    if(user.contactEmail3 != null)
    {
      contactsEmail.add(user.contactEmail3);
    }
  }
  return contactsEmail;
}


sendEmail(String subject, String body, String recipient) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipient],
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  int _timer = 3;
  Timer? _photoTimer;
  Completer<void>? _previousCaptureCompleter;
  File? selectedImage;
  String? message = "";

  uploadImage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://4d60-102-188-107-183.eu.ngrok.io/upload"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resjason = jsonDecode(res.body);
    message = resjason['message'];
    if(message != "safe driving")
      {

      }
    print(
        "################################################################## $message");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = CameraController(widget.cameras![0], ResolutionPreset.medium);
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
      _controller!.setFlashMode(FlashMode.off);
      // Take the picture.
      final XFile file = await _controller!.takePicture();
      selectedImage = File(file.path);
      // Save the picture to the device's gallery.
      //final result = await ImageGallerySaver.saveFile(file.path);
      //print('Picture saved to gallery: $result');
      setState(() {});
      uploadImage();
      completer.complete();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _startTimer() async {
    _photoTimer = Timer.periodic(Duration(seconds: _timer), (timer) {
      _takePicture();
    });
  }

  void _stopTimer() {
    _photoTimer?.cancel();
  }

  String testEmailMessage = "test";

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }
    final userEmail = Provider.of<StringData>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Camera Demo'),
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/Images/home.jpg'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1,
                  sigmaY: 1,
                ),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  Container(
                    height: 250,
                    width: 350,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 15.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: CameraPreview(_controller!),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    child: buildBlur(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 300,
                        height: 60,
                        padding: EdgeInsets.all(5),
                        color: Colors.white.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: _startTimer,
                                child: Text('Start',
                                    style: TextStyle(
                                      fontSize: 25,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ))),
                            TextButton(
                                onPressed: () async{
                                  _stopTimer();
                                  List<dynamic> contactsEmail =await getContactEmail(userEmail.email);
                                  print("############################### contactsEmail = ${contactsEmail} ###################################");
                                  if (testEmailMessage == "test") {
                                    for(int i = 0; i<contactsEmail.length;i++)
                                      {
                                        sendEmail(
                                            "test 1 successfully",
                                            "what is the next step",
                                            contactsEmail[i]);
                                      }
                                  }
                                },
                                child: Text('Stop',
                                    style: TextStyle(
                                      fontSize: 25,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildBlur(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 300,
                      height: 60,
                      padding: EdgeInsets.all(5),
                      color: Colors.white.withOpacity(0.4),
                      child: Center(
                        child: Text(
                          message!,
                          style: TextStyle(
                            fontSize: 25,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBlur({
  required Widget child,
  required BorderRadius borderRadius,
  double sigmaX = 10,
  double sigmaY = 10,
}) =>
    ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
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
