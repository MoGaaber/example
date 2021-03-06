import 'package:flutter/material.dart';
import 'package:flutter_downloader_example/pages/home/logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyButton extends StatelessWidget {
  String text;
  Color color;
  VoidCallback onPressed;
  MyButton(this.text, this.color, this.onPressed);
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    return FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: color,
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp),
        ));
  }
}
