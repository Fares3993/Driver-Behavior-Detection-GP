import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

double getHeight(BuildContext context, double fraction) {
  return MediaQuery.of(context).size.height * fraction;
}
double getWidth(BuildContext context, double fraction) {
  return MediaQuery.of(context).size.width * fraction;
}
ButtonStyle getButtonStyle(double w , double h,Color c) {
  return ElevatedButton.styleFrom(
      minimumSize: Size(w, h),
      backgroundColor: c,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))));
}
Widget div(double h,double i)=> Divider(
  color: Colors.black,
  height: h,
  thickness: 1,
  endIndent: i,

);

Widget appBarLogo()
{
  return Container(
    height: 50,
    width: 50,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('lib/Images/Logo.png')),
    ),
  );
}

Widget BuildTextField(TextEditingController controller,String hintTxt,IconData iconData,TextInputType inputType) {
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
      keyboardType: inputType,
      controller: controller,
      style: TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14),
        prefixIcon: Icon(
          iconData,
          color: Color(0xff5ac18e),
        ),
        hintText: hintTxt,
        hintStyle: TextStyle(color: Colors.black45),
      ),
    ),
  );
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

Widget resultBox(String prefImage,String suffImage,String result)
{
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: 300,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2))
          ]),
      child: Row(
        children: [
          Image.asset(prefImage,height: 50,),
          Container(
            width: 190,
            child: Text(
              result,
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          Image.asset(suffImage,height: 50,),
        ],
      ),
    ),
  );
}
Widget getText(int index, BuildContext context) {
  if (index == 0) {
    return Container(
      width: getWidth(context, 0.75),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              span('The main objective of the project is developing a '),
              spanBold('driver Behavior detection software '),
              span('to help drivers '),
              spanBold('stay safe')
            ]),
      ),
    );
  }
  else if (index == 1) {
    return Container(
      width: getWidth(context, 0.75),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              span("The system detects whether the driver is "),
              spanBold("Distracted "),
              span("or not")
            ]),
      ),
    );
  }
  else if (index == 2) {
    return Container(
      width: getWidth(context, 0.75),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              span("The system detects whether the driver is wearing a "),
              spanBold("\nseat belt "),
              span("or not")
            ]),
      ),
    );
  }
  else if (index == 3) {
    return Container(
      width: getWidth(context, 0.75),
      child: RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              span("The system detects whether the driver is "),
              spanBold("Drowsy "),
              span("or not")
            ]),
      ),
    );
  }
  return Text("data");
}

TextSpan spanBold(String txt) {
  return TextSpan(
    text: txt,
    style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff5ac18e)),
  );
}

TextSpan span(String txt) {
  return TextSpan(
    text: txt,
    style: TextStyle(fontSize: 22),
  );
}