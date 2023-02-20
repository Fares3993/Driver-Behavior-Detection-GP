import 'package:flutter/material.dart';

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
Widget div(double h)=> Divider(
  color: Colors.black,
  height: h,
  thickness: 0.6,
);
Widget ContactField()
{
  return TextField(
    decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        hintText: 'Enter Phone Number',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
    style: TextStyle(color: Colors.white, fontSize: 18),
  );
}