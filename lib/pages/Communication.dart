import 'package:driver_behaviour_gp/Widgets.dart';
import 'package:flutter/material.dart';

class contact_us extends StatefulWidget {
  const contact_us({Key? key}) : super(key: key);

  @override
  State<contact_us> createState() => _contact_usState();
}

class _contact_usState extends State<contact_us> {
  @override
  Widget build(BuildContext context) {
    double h = getHeight(context, 0.01);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          appBarLogo()

        ],
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: getHeight(context, 0.3),
                    width: getWidth(context, 0.5),
                    child: Image(
                      image: AssetImage('lib/Images/Contact.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      'You can contact with our team through this contacts if you face any problem and we will try to solve the problem and communicate with you immediately.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: getHeight(context, 0.02),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact with us',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  div(h,0),
                  SizedBox(height: getHeight(context, 0.03),),
                  ContactField('lib/Images/gmail.png', '    faresahmed3993@gmail.com', context, 30),
                  SizedBox(height: getHeight(context, 0.02),),
                  ContactField('lib/Images/outlook.png', ' faresahmed3993@outlook.com', context, 40),
                  SizedBox(height: getHeight(context, 0.01),),
                  ContactField('lib/Images/GitHub.png', 'https://github.com/Fares3993', context,45),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget ContactField(String path,String email ,BuildContext context, double iconSize)
{
  return Row(
    children: [
      Container(
        height: iconSize,
        child: Image(
          image: AssetImage(path),
        ),
      ),
      SizedBox(width: getWidth(context, 0.03),),
      Text(email,style: TextStyle(fontSize: 16),),

    ],
  );
}