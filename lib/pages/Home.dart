import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/pages/AddContact.dart';
import 'package:driver_behaviour_gp/pages/AlertSounds.dart';
import 'package:driver_behaviour_gp/pages/CameraScreen.dart';
import 'package:driver_behaviour_gp/pages/Communication.dart';
import 'package:driver_behaviour_gp/pages/Help.dart';
import 'package:driver_behaviour_gp/pages/email.dart';
import 'package:driver_behaviour_gp/pages/login.dart';
import 'package:driver_behaviour_gp/pages/videoPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:driver_behaviour_gp/my_flutter_app_icons.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Home({super.key,required this.cameras});

  @override
  State<Home> createState() => _HomeState();
}
//
class _HomeState extends State<Home> {
  FirebaseAuth instance = FirebaseAuth.instance;
  String? getUser="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance.authStateChanges().listen((User? user) {

      if (user == null) {
        print('no user');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login(cameras: widget.cameras,)));
      } else
        print('there is a user');
      setState(() {
        getUser = user!.email;
      });
    });
  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final userEmail = Provider.of<StringData>(context);
    userEmail.updateEmail(getUser!);
  }
  @override
  Widget build(BuildContext context) {
    double h = getHeight(context, 0.01);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.add_alert_sharp,color: Colors.black,),
              title: Text('Alert Sounds'),
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>AlertSounds())),
            ),
            div(h),
            ListTile(
              leading: Icon(Icons.add_ic_call,color: Colors.black,),
              title: Text('Add more contact'),
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddContact())),
            ),
            div(h),
            ListTile(
              leading: Icon(Icons.help_outline,color: Colors.black,),
              title: Text('Help'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpScreen())),
            ),
            div(h),
            ListTile(
              leading: Icon(Icons.logout,color: Colors.black,),
              title: Text('Logout'),
              onTap: ()=> instance.signOut(),
            ),
            div(h),
            SizedBox(height: getHeight(context, 0.55),),
            Text('Communicate'),
            div(h/2),
            ListTile(
              leading: Icon(MyFlutterApp.telegram_plane,color: Colors.black,),
              title: Text('Contact us'),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>contact_us()) ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/Images/home.jpg'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getHeight(context, 0.38),
              ),
              Text(
                'Start Your Safety Trip',
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'font2',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getHeight(context, 0.2),),

              ElevatedButton(
                style: getButtonStyle(250, 50,Colors.black),
                child: Text(
                  'Open Camera',
                  style: TextStyle(fontSize: 25,fontFamily: 'font2'),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraScreen(cameras: widget.cameras)));
                },
              ),
              SizedBox(height: getHeight(context, 0.03),),

              ElevatedButton(
                style: getButtonStyle(250, 50,Colors.black),
                child: Text(
                  'Recorded Video',
                  style: TextStyle(fontSize: 25,fontFamily: 'font2'),
                ),
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> EmailScreen()));
                  //Navigator.pushNamed(context, '/videoPage',arguments: "Recorded Video");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


