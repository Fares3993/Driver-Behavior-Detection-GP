import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets.dart';
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
    alertSound.updateAlert(Value as String);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          appBarLogo()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              Image.asset("lib/Images/Alert.png"),
              SizedBox(height: 30,),
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
                      color: Color(0xff5ac181),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton(
                    dropdownColor:Color(0xff5ac181) ,
                    borderRadius: BorderRadius.circular(10),
                    value: Value,
                    icon: Icon(Icons.keyboard_arrow_down_sharp),
                    iconSize: 30,
                    isExpanded: true,
                    hint: Text(Value!),
                    style: TextStyle(fontSize: 22, color: Colors.white),
                    items: Items.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem));
                    }).toList(),

                    onChanged: (newValue) async{
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
            ],
          ),
        ),
      ),
    );
  }
}
