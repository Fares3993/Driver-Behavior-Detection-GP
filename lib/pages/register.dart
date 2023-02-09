import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _email, _password, _name;
  FirebaseAuth instance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Enter your name'),
            onChanged: (value) {
              setState(() {
                this._name = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter your email'),
            onChanged: (value) {
              setState(() {
                this._email = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter your password'),
            onChanged: (value) {
              setState(() {
                this._password = value;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text('Register'),
            onPressed: () async {
              try {
                UserCredential credential =
                    await instance.createUserWithEmailAndPassword(
                        email: _email!, password: _password!);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('weak-password');
                } else if (e.code == 'email-already-in-use') {
                  print('email-already-in-use');
                }
              }
            },
          ),
        ],
      )),
    );
  }
}
