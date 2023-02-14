import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _email, _password;
  bool _seen = true;

  FirebaseAuth instance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.black,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Center(
                child: Text(
                  "Welcome!",
                  style: TextStyle(
                      fontFamily: "font1", fontSize: 20, color: Colors.white70),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: height * 0.8,
                width: width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width * 0.7,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: width * 0.40,
                                      height: height * 0.08,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Center(
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Register()));
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ))
                                ]),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'Enter your email'),
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
                            obscureText: this._seen,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      this._seen = !this._seen;
                                    });
                                  },
                                  child: Icon(
                                    this._seen
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: 'Enter your password'),
                            onChanged: (value) {
                              setState(() {
                                this._password = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          ElevatedButton(
                            style: buttonStyle,
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (this._email == null) {
                                Dialogue(context, 'please enter your email');
                              } else if (this._password == null) {
                                Dialogue(context, 'please enter your password');
                              } else {
                                try {
                                  UserCredential credential =
                                      await instance.signInWithEmailAndPassword(
                                          email: _email!, password: _password!);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Dialogue(context, 'there is no user corresponding to the given email.');
                                  } else if (e.code == 'wrong-password') {
                                    Dialogue(context,'wrong password');
                                  }else if (e.code == 'invalid-email') {
                                    Dialogue(context,
                                        'the email address is not valid');
                                  }
                                }
                              }
                            },
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(200, 50),
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))));
