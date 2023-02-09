import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _email, _password, _name;
  bool _seen = true;
  FirebaseAuth instance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Register'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: Text(
                  "Welcome!",
                  style: TextStyle(
                      fontFamily: "font5", fontSize: 20, color: Colors.white70),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()));
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Center(
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )),
                                ]),
                          ),
                          SizedBox(height: 50),
                          TextField(
                            decoration: InputDecoration(hintText: 'user name'),
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
                            decoration: InputDecoration(hintText: 'email'),
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
                                hintText: 'password'),
                            onChanged: (value) {
                              setState(() {
                                this._password = value;
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
                                hintText: 'confirm password'),
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
                              'Register',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              try {
                                UserCredential credential = await instance
                                    .createUserWithEmailAndPassword(
                                        email: _email!, password: _password!);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('weak-password');
                                } else if (e.code == 'email-already-in-use') {
                                  print('email-already-in-use');
                                }
                              }
                            },
                          ),
                          /////////////////////////////////////////////////////////////////////////////////////////
                          // SizedBox(
                          //   height: 50,
                          // ),
                          // TextField(
                          //   decoration:
                          //   InputDecoration(hintText: 'Enter your email'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       this._email = value;
                          //     });
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // TextField(
                          //   obscureText: seen,
                          //   decoration: InputDecoration(
                          //       suffixIcon: GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             seen = !seen;
                          //           });
                          //         },
                          //         child: Icon(
                          //           seen
                          //               ? Icons.visibility_off
                          //               : Icons.visibility,
                          //           color: Colors.grey,
                          //         ),
                          //       ),
                          //       hintText: 'Enter your password'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       this._password = value;
                          //     });
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 80,
                          // ),
                          // ElevatedButton(
                          //   style: buttonStyle,
                          //   child: Text(
                          //     'Login',
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          //   onPressed: () async {
                          //     try {
                          //       UserCredential credential =
                          //       await instance.signInWithEmailAndPassword(
                          //           email: _email!, password: _password!);
                          //       Navigator.pushReplacement(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => Home(),
                          //         ),
                          //       );
                          //     } on FirebaseAuthException catch (e) {
                          //       if (e.code == 'user-not-found') {
                          //         print('user not found');
                          //       } else if (e.code == 'wrong-password') {
                          //         print('wrong-password');
                          //       }
                          //     }
                          //   },
                          // ),
                        ]),
                  ),
                ),
              ),
              // TextField(
              //   decoration: InputDecoration(hintText: 'Enter your name'),
              //   onChanged: (value) {
              //     setState(() {
              //       this._name = value;
              //     });
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextField(
              //   decoration: InputDecoration(hintText: 'Enter your email'),
              //   onChanged: (value) {
              //     setState(() {
              //       this._email = value;
              //     });
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextField(
              //   decoration: InputDecoration(hintText: 'Enter your password'),
              //   onChanged: (value) {
              //     setState(() {
              //       this._password = value;
              //     });
              //   },
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // ElevatedButton(
              //   child: Text('Register'),
              //   onPressed: () async {
              //     try {
              //       UserCredential credential =
              //           await instance.createUserWithEmailAndPassword(
              //               email: _email!, password: _password!);
              //       Navigator.pushReplacement(context,
              //           MaterialPageRoute(builder: (context) => Home()));
              //     } on FirebaseAuthException catch (e) {
              //       if (e.code == 'weak-password') {
              //         print('weak-password');
              //       } else if (e.code == 'email-already-in-use') {
              //         print('email-already-in-use');
              //       }
              //     }
              //   },
              // ),
            ],
          )),
        ),
      ),
    );
  }
}
