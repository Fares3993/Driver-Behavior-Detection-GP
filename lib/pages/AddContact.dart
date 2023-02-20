import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:driver_behaviour_gp/pages/Home.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
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
                    ContactField(),
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
                    ContactField(),
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

                    ContactField(),
                    SizedBox(
                      height: getHeight(context, 0.08),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: getButtonStyle(200, 50,Colors.white),
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 25,fontFamily: 'font2',color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
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
