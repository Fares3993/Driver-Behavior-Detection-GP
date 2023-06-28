import 'package:audioplayers/audioplayers.dart';
import 'package:driver_behaviour_gp/pages/register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
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
    if (user.contactEmail1 != null) {
      contactsEmail.add(user.contactEmail1);
    }
    if (user.contactEmail2 != null) {
      contactsEmail.add(user.contactEmail2);
    }
    if (user.contactEmail3 != null) {
      contactsEmail.add(user.contactEmail3);
    }
  }
  return contactsEmail;
}

sendEmail(String subject, String body, String recipient,File selectedImage) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: [recipient],
    isHTML: false,
    attachmentPaths: [selectedImage.path]
  );
  await FlutterEmailSender.send(email);
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  int _timer = 3;
  Timer? _photoTimer;

  Completer<void>? _previousCaptureCompleter;
  File? selectedImage;
  String? message = "",
      model1Message = "",
      model2Message = "",
      model3Message = "";
  int count = 0;
  List<String> messageSplit = [];

  uploadImage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://07dc-154-189-49-55.eu.ngrok.io/upload"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resjason = jsonDecode(res.body);
    message = resjason['message'];
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

  final player = AudioCache();
  AudioPlayer? audioPlayer = null;

  Future<void> _takePicture(String alert,StringData userEmail) async {
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

      if (message != "") {
        messageSplit = message!.split("/");
        model1Message = messageSplit[0];
        model2Message = messageSplit[1];
        model3Message = messageSplit[2];
      }
      print("##################################### model3Message = $model3Message #####################################");
      if (model1Message != "safe driving" && model2Message != "Seat belt" && (model3Message != "Not Drosy" || model3Message != "Open eye")) {
        if(model3Message != "Not Drosy" || model3Message != "Open eye")
          {
            count++;
            print("##################################### count = $count #####################################");

          }
        else
          {
            count=0;
          }
        if (audioPlayer != null) {
          audioPlayer?.stop();
        }
        if (alert == "") {
          alert = "Sound 1";
        }
        audioPlayer = await player.play("${alert}.mp3");
        //################################################################3
        String location = "";
        print("######################## count in email code = $count  #############################");
        if (count == 3) {
          print("######################## open email code #############################");
          try {
            final bool hasPermission = await Geolocator.isLocationServiceEnabled();
            if (!hasPermission) {
              throw 'Location service is disabled';
            }

            final Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            final String latitude = position.latitude.toString();
            final String longitude = position.longitude.toString();

            final String googleMapsLink =
                'https://www.google.com/maps?q=$latitude,$longitude';
            location = '$googleMapsLink';
          } catch (error) {
            throw 'Failed to send Location: $error';
          }
          List<dynamic> contactsEmail =
          await getContactEmail(userEmail.email);
          for (int i = 0;
          i < contactsEmail.length;
          i++) {
            sendEmail(
                "Safe Driving",
                'Your friend is feeling drowsy while driving, please help him and his location is:\n\n'+ location,
                contactsEmail[i],selectedImage!);
          }
          print("timer stopped at count = $count");
          _stopTimer();
        }
      }
      completer.complete();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _startTimer(String alert ,StringData userEmail) async {
    _photoTimer = Timer.periodic(Duration(seconds: _timer), (timer) {
      _takePicture(alert, userEmail);
    });
  }

  void _stopTimer() {
    _photoTimer?.cancel();
  }

  //String testEmailMessage = "test";

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Container();
    }
    final userEmail = Provider.of<StringData>(context);
    final alertSound = Provider.of<StringData>(context);
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
                                onPressed: () {
                                  _startTimer(alertSound.alert,userEmail);
                                },
                                child: Text('Start',
                                    style: TextStyle(
                                      fontSize: 25,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ))),
                            TextButton(
                                onPressed: (){
                                  _stopTimer();
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
                          model1Message!,
                          style: TextStyle(
                            fontSize: 25,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                          model2Message!,
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

