import 'package:driver_behaviour_gp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth instance = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('no user');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else
        print('there is a user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                instance.signOut();
              }),
        ],
        title: Text('Home'),
      ),
      body: Center(child: Text('Home Screen')),
    );
  }
}
