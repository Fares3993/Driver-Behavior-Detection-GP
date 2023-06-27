import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          appBarLogo()

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
            Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                color: Color(0xff5ac181),
                shape: BoxShape.circle,),
              child: Center(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('lib/Images/alertIcon.png'),
                      height: 100,
                      width: 130,
                    ),
                    Text(
                      "Alert Sounds",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'it allows the User to choose the sound alarm that invokes when the user tends to fail asleep,being drunk or seat belt not worn situation',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              div(50,0),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  color: Color(0xff5ac181),
                  shape: BoxShape.circle,),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "lib/Images/SafetyIcon.png", width: 60, height: 100,),
                      Text(
                        "Increase safety",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'it allows the User to increase his safety by adding more phone numbers to the closest people so when he is driving indanger the application sends message to those people with the drivers location to help him.',
                style: TextStyle(fontSize: 17),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
