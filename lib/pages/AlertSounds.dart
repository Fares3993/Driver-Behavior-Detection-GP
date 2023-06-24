import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class AlertSounds extends StatefulWidget {
  const AlertSounds({Key? key}) : super(key: key);

  @override
  State<AlertSounds> createState() => _AlertSoundsState();
}

class _AlertSoundsState extends State<AlertSounds> {
  final player = AudioCache();
  String? Value = 'Sound 1';
  SharedPreferences ?prefs;
  saveData(String value) async{
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('sound', value);
  }
  getData() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Value= prefs!.getString('sound')??'Sound 1';
    });

  }
  AudioPlayer? audioPlayer = null;

  List Items = ['Sound 1', 'Sound 2', 'Sound 3', 'Sound 4', 'Sound 5'];

  @override
  Widget build(BuildContext context) {
    final alertSound = Provider.of<StringData>(context);
    getData();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 400,
                width: 300,
                child: Image(
                  image: AssetImage('lib/Images/Alert.png'),
                ),
              ),
              Text(
                'Select Sound',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Times New Roman"),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/Images/bg.png')),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton(
                    value: Value,
                    icon: Icon(Icons.keyboard_arrow_down_sharp),
                    iconSize: 30,
                    isExpanded: true,
                    hint: Text(Value!),
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    items: Items.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    onChanged: (newValue) async{
                      alertSound.updateAlert(newValue as String);
                      if(audioPlayer != null)
                        {
                          audioPlayer?.stop();
                        }
                      audioPlayer = await player.play('${newValue as String}.mp3');
                      setState(() {
                        Value = newValue as String?;
                        saveData(Value!);
                      });
                    },
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       final player = AudioCache();
              //       player.play('Sound 1.mp3');
              //     },
              //     child: Text("Start Sound"))
            ],
          ),
        ),
      ),
    );
  }
}
