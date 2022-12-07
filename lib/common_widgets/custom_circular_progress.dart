import 'package:flutter/material.dart';
import 'package:cat_facts/res/colors.dart';

class CustomCircularProgress extends StatelessWidget {
  final Color color, backgroundColor;
  final double? value, strokeWidth;
  const CustomCircularProgress(
      {Key? key,
      this.color = black,
      this.backgroundColor = transparent,
      this.value,
      this.strokeWidth,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 3,
        color: color,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        value: value,
      ),
    );
  }
}
