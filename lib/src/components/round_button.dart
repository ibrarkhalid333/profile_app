import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:profile_app/main.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.onPress,
    this.title = '',
    this.height = 40,
    this.width = 40,
  }) : super(key: key);
  final String title;
  final double height, width;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
