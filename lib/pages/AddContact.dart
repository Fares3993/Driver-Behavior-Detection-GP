import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:driver_behaviour_gp/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

class _AddContactState extends State<AddContact> {
  Future<UserData1?> getUserByEmail1(String email) async {
    final userQuery =
        await usersCollection.where('userEmail', isEqualTo: email).get();

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data() as Map<String, dynamic>;
      final user = UserData1(
        name: userData['name'],
        userEmail: email,
        contactEmail: userData['contactEmail'],
        userPhone: userData['userPhone'],
        contactEmail1: userData['contactEmail1'] ?? null,
        contactEmail2: userData['contactEmail2'] ?? null,
        contactEmail3: userData['contactEmail3'] ?? null,
      );
      return user;
    } else {
      return null;
    }
  }

  void getUserAndAddContacts(String email, String contactEmail,int index) async {
    final userService = UserService1();

    // Get the user based on email
    final user = await userService.getUserByEmail(email);

    if (user != null) {
      // Add the address to the user
      if(index == 1)
        {
          user.contactEmail1 = contactEmail;
        }
      else if(index == 2)
      {
        user.contactEmail2 = contactEmail;
      }
      else if(index == 3)
      {
        user.contactEmail3 = contactEmail;
      }


      // Update the user document in Firestore with the new address
      await userService.addContactToUser(email, contactEmail,index);
    } else {
      print('User not found');
    }
  }

  final TextEditingController contactEmailController1 = TextEditingController();
  final TextEditingController contactEmailController2 = TextEditingController();
  final TextEditingController contactEmailController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stringData = Provider.of<StringData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getHeight(context, 0.15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Row(
                children: [
                  Icon(
                    Icons.safety_check,
                    color: Colors.greenAccent,
                    size: 40,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Icrease the safety feature',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'is to add more phone numbers to the most closest people to you to be more safe',
                                style: TextStyle(
                                  fontSize: 18,
                                ))
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getHeight(context, 0.05),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact 1',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                    TextField(
                      controller: contactEmailController1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Enter Phone Number',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16)),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.05),
                    ),
                    Text(
                      'Contact 2',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                    TextField(
                      controller: contactEmailController2,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Enter Phone Number',
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 16)),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.05),
                    ),
                    Text(
                      'Contact 3',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.02),
                    ),
                    TextField(
                      controller: contactEmailController3,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Enter Phone Number',
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 16)),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: getHeight(context, 0.08),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: getButtonStyle(200, 50, Colors.white),
                        child: Text(
                          'Done',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'font2',
                              color: Colors.black),
                        ),
                        onPressed: () {
                          if(contactEmailController1.text !="")
                            {
                              getUserAndAddContacts(stringData.value, contactEmailController1.text,1);

                            }
                          if(contactEmailController2.text !="")
                          {
                            getUserAndAddContacts(stringData.value, contactEmailController2.text,2);

                          }
                          if(contactEmailController3.text !="")
                          {
                            getUserAndAddContacts(stringData.value, contactEmailController3.text,3);

                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
