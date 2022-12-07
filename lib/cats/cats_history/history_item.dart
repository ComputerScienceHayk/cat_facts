import 'package:cat_facts/constants/app_values.dart';
import 'package:flutter/material.dart';
import 'package:cat_facts/res/colors.dart';
import 'package:cat_facts/api_service/api_service.dart';
import 'package:cat_facts/main.dart';

class HistoryItem extends StatelessWidget {
  final CatModel cat;
  const HistoryItem({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: StyleText.blackText(16, FontWeight.w500),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * .02),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(cat.fact ?? AppValues.unknownFact),
              ),
              SizedBox(width: size.width * .06),
              Expanded(
                child: Text(cat.date ?? AppValues.unknownDate),
              )
            ],
          ),
        ),
    );
  }
}
