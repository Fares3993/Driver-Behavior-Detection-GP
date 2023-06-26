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
Widget div(double h)=> Divider(
  color: Colors.black,
  height: h,
  thickness: 1,
  endIndent: 50,

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

// Widget BuildEmail(TextEditingController emailController,String hintTxt) {
//   return Container(
//     width: 300,
//     alignment: Alignment.centerLeft,
//     decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
//         ]),
//     height: 50,
//     child: TextField(
//       keyboardType: TextInputType.emailAddress,
//       controller: emailController,
//       style: TextStyle(color: Colors.black, fontSize: 16),
//       decoration: InputDecoration(
//         border: InputBorder.none,
//         contentPadding: EdgeInsets.only(top: 14),
//         prefixIcon: Icon(
//           Icons.email,
//           color: Color(0xff5ac18e),
//         ),
//         hintText: hintTxt,
//         hintStyle: TextStyle(color: Colors.black45),
//       ),
//     ),
//   );
// }
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



//##############################
