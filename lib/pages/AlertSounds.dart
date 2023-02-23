import 'package:flutter/material.dart';

class AlertSounds extends StatefulWidget {
  const AlertSounds({Key? key}) : super(key: key);

  @override
  State<AlertSounds> createState() => _AlertSoundsState();
}

class _AlertSoundsState extends State<AlertSounds> {
  String? Value;
  List Items = ['Sound1', 'Sound2', 'Sound3', 'Sound4', 'Sound5'];

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(left: 16,right: 16),
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
                    hint: Text('Default'),
                    style: TextStyle(fontSize: 22,color: Colors.black),
                    items: Items.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        Value = newValue as String?;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
