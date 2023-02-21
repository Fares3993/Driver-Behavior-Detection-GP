import 'dart:io';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool play = true;
  //*************************************************************************


  File? _video;
  VideoPlayerController? _videoPlayerController;
  final picker = ImagePicker();

// This funcion will helps you to pick a Video File
  _pickVideoFromGallery() async {
    PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);
    _video = File(pickedFile!.path);
    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  // final picker = ImagePicker();
// This funcion will helps you to pick and Image from Camera
  _pickVideoFromCamera() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.camera);
    _video = File(pickedFile!.path);
    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  //************************************************************************

  @override
  Widget build(BuildContext context) {
    var choice = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            if (_video != null)
              _videoPlayerController!.value.isInitialized
                  ? Column(
                      children: [

                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 2,
                            child: AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_videoPlayerController!.value.isPlaying) {
                                  _videoPlayerController!.pause();
                                  play = false;
                                } else {
                                  _videoPlayerController!.play();
                                  play = true;
                                }
                              });
                            },
                            child: Icon(
                              play ? Icons.pause : Icons.play_arrow,
                              size: 30,
                              color: Colors.white,
                            ))
                      ],
                    )
                  : Container()
            else
              Center(
                  child: Text(
                "Click on Pick Video to select video",
                style: TextStyle(fontSize: 18.0),
              )),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(choice == 'Open Camera')
            _pickVideoFromCamera();
          else if(choice == 'Recorded Video')
            _pickVideoFromGallery();
        },
        child: Icon(Icons.video_call_rounded),
      ),
    );
  }
}
