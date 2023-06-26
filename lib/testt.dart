import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData1 {
  final String name;
  final String userEmail;
  final String contactEmail;
  final String userPhone;
  String? contactEmail1;
  String? contactEmail2;
  String? contactEmail3;

  UserData1(
      {required this.name,
        required this.userEmail,
        required this.contactEmail,
        required this.userPhone,
        this.contactEmail1,
        this.contactEmail2,
        this.contactEmail3});

  // Convert User object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userEmail': userEmail,
      'contactEmail': contactEmail,
      'userPhone': userPhone,
      'contactEmail1': contactEmail1,
      'contactEmail2': contactEmail2,
      'contactEmail3': contactEmail3,
    };
  }

  // Create User object from a Firestore document snapshot
  factory UserData1.fromSnapshot(DocumentSnapshot snapshot) {
    final data1 = snapshot.data() as Map<String, dynamic>;
    return UserData1(
      name: data1['name'],
      userEmail: data1['userEmail'],
      contactEmail: data1['contactEmail'],
      userPhone: data1['userPhone'],
      contactEmail1: data1['contactEmail1'],
      contactEmail2: data1['contactEmail2'],
      contactEmail3: data1['contactEmail3'],
    );
  }
}

class UserService1 {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> addUser1(UserData1 user) async {
    await usersCollection.doc(user.userEmail).set(user.toMap());
  }

  Future<List<UserData1>> getUsers() async {
    final querySnapshot = await usersCollection.get();
    return querySnapshot.docs
        .map((doc) => UserData1.fromSnapshot(doc))
        .toList();
  }

  Future<UserData1?> getUserByEmail(String email) async {
    final docSnapshot = await usersCollection.doc(email).get();
    if (docSnapshot.exists) {
      return UserData1.fromSnapshot(docSnapshot);
    }
    return null;
  }

  Future<void> addContactToUser(
      String email, String ContactEmail, int index) async {
    final userQuery =
    await usersCollection.where('userEmail', isEqualTo: email).get();
    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
      await userDoc.reference.update({'contactEmail$index': ContactEmail});
    }
  }
}

class Register extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Register({super.key, required this.cameras});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController? passwordController, confirmPasswordController;
  bool _seen = true;
  bool _color = true;
  FirebaseAuth instance = FirebaseAuth.instance;
  final UserService1 userService = UserService1();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();

  void addUser1() {
    final user = UserData1(
      name: nameController.text,
      userEmail: userEmailController.text,
      contactEmail: contactEmailController.text,
      userPhone: userPhoneController.text,
    );
    userService.addUser1(user);
  }

  Widget BuildPassword(TextEditingController passwordController, bool icon) {
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
              child: icon
                  ? Icon(this._seen ? Icons.visibility_off : Icons.visibility,
                  color: this._color ? Colors.grey : Color(0xff5ac18e))
                  : null),
          hintText: 'Enter your password',
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Text(
                      "Register",
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
                      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.055,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Login(
                                                    cameras: widget.cameras,
                                                  )));
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff5ac18e),
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: getWidth(context, 0.02),
                                    ),
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
                                            'Register',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ]),
                            ),
                            SizedBox(height: 50),

                            Container(
                              height: 180,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BuildTextField(nameController, "name",
                                        Icons.person, TextInputType.text),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BuildTextField(userEmailController, "Email",
                                        Icons.email, TextInputType.emailAddress),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BuildTextField(
                                        contactEmailController,
                                        "Contact Email",
                                        Icons.attach_email_rounded,
                                        TextInputType.emailAddress),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BuildTextField(
                                        userPhoneController,
                                        "Phone Number",
                                        Icons.phone,
                                        TextInputType.number),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      obscureText: this._seen,
                                      controller: passwordController,
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
                                      // onChanged: (value) {
                                      //   setState(() {
                                      //     this._password = value;
                                      //   });
                                      // },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: confirmPasswordController,
                                      obscureText: this._seen,
                                      decoration: InputDecoration(
                                          hintText: 'confirm password'),
                                      // onChanged: (value) {
                                      //   this._confirmPassword = value;
                                      // },
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //TextButton(onPressed: addUser1, child: Text("Confirm??",style: TextStyle( fontSize: 20, color: Colors.black),)),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: getButtonStyle(200, 50, Colors.black),
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {

                                if (this.nameController.text == null) {
                                  Dialogue(context, 'please enter your name');
                                } else if (this.userEmailController.text == null) {
                                  Dialogue(context, 'please enter your email');
                                } else if (this.contactEmailController.text ==
                                    null) {
                                  Dialogue(
                                      context, 'please enter your contact email');
                                } else if (this.userPhoneController.text == null) {
                                  Dialogue(
                                      context, 'please enter your phone number');
                                } else if (passwordController!.text == null) {
                                  Dialogue(context, 'please enter your password');
                                } else if (confirmPasswordController!.text == null) {
                                  Dialogue(context, 'please confirm your password');
                                } else if (passwordController!.text !=
                                    confirmPasswordController!.text) {
                                  Dialogue(context, 'Passwords Don\'t match');
                                } else {
                                  try {
                                    addUser1();
                                    UserCredential credential = await instance
                                        .createUserWithEmailAndPassword(
                                        email: userEmailController.text!,
                                        password: passwordController!.text);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home(
                                              cameras: widget.cameras,
                                            )));
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      Dialogue(context,
                                          "the password is not strong enough");
                                    } else if (e.code == 'email-already-in-use') {
                                      Dialogue(context,
                                          'there already exists an account with the given email address');
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
                  //),
                ],
              )),
        ),
      ),
    );
  }
}

void Dialogue(BuildContext context, String Message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 10, top: 15),
                    child: Text(
                      Message,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "font2",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text("OK",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "font2",
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                )
              ],
            ),
          ),
        );
      });
}
