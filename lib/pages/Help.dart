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
      // appBar: AppBar(
      //   title: Text("help"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 75,),
                Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('lib/Images/bg.png')
                    ),
                    borderRadius: BorderRadius.circular(75)
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Image(image: AssetImage('lib/Images/alertIcon.png'),height: 100,width: 130,),
                        Text("Alert Sounds",style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Text('it allows the User to choose the sound alarm that invokes when the user tends to fail asleep,being drunk or seat belt not worn situation',style: TextStyle(fontSize: 17),),
                SizedBox(height: 20,),
                div(50),
                SizedBox(height: 20,),
                Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/Images/bg.png')
                      ),
                      borderRadius: BorderRadius.circular(75)
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.safety_check_outlined,size: 100,),
                        Text("Increase the safety",style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Text('it allows the User to increase his safety by adding more phone numbers to the closest people so when he is driving indanger the application sends message to those people with the drivers location to help him.',style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
