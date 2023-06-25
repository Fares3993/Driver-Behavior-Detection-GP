import 'package:camera/camera.dart';
import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Login extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Login({super.key, required this.cameras});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _seen = true;
  bool _color = true;

  FirebaseAuth instance = FirebaseAuth.instance;

  Widget BuildPassword(TextEditingController passwordController) {
    return Container(
      width: 300,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      height: 50,
      child: TextField(
        obscureText: this._seen,
        controller: passwordController,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xff5ac18e),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                this._seen = !this._seen;
                this._color = !this._color;
              });
            },
            child: Icon(this._seen ? Icons.visibility_off : Icons.visibility,
                color: this._color ? Colors.grey : Color(0xff5ac18e)),
          ),
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stringData = Provider.of<StringData>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: getHeight(context, 1),
          width: getWidth(context, 1),
          color: Colors.black,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getHeight(context, 0.1),
              ),
              Center(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "font5"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.black26,
                //HexColor("090150"),//Color(0x00021A),
                backgroundImage: AssetImage("lib/Images/Logo.png"),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: getHeight(context, 0.55),
                width: getWidth(context, 0.9),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: getWidth(context, 0.7),
                          height: getHeight(context, 0.055),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(40)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: getWidth(context, 0.40),
                                    height: getHeight(context, 0.055),
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  width: getWidth(context, 0.02),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Register(
                                                    cameras: widget.cameras,
                                                  )));
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff5ac18e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                              ]),
                        ),
                        SizedBox(
                          height: 50,
                        ),

                        // TextField(
                        //   keyboardType: TextInputType.emailAddress,
                        //   controller: emailController,
                        //   decoration:
                        //       InputDecoration(hintText: 'Enter your email'),
                        // ),
                        BuildEmail(emailController),
                        SizedBox(
                          height: 15,
                        ),
                        BuildPassword(passwordController),
                        SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                          style: getButtonStyle(200, 50, Colors.black),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            stringData.updateEmail(emailController.text!);
                            if (this.emailController.text == null) {
                              Dialogue(context, 'please enter your email');
                            } else if (this.passwordController.text == null) {
                              Dialogue(context, 'please enter your password');
                            } else {
                              try {
                                UserCredential credential =
                                    await instance.signInWithEmailAndPassword(
                                        email: emailController.text!,
                                        password: passwordController.text!);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                      cameras: widget.cameras,
                                    ),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Dialogue(context,
                                      'there is no user corresponding to the given email.');
                                } else if (e.code == 'wrong-password') {
                                  Dialogue(context, 'wrong password');
                                } else if (e.code == 'invalid-email') {
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
            ],
          )),
        ),
      ),
    );
  }
}
