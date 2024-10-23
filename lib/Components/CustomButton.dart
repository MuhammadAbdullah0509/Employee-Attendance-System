

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Resources/CustomColor.dart';
import '../Resources/CustomSize.dart';

class CustomButton extends StatelessWidget {
  String title;
  final VoidCallback? onTap;
  bool loading=false;
  CustomButton({super.key, required this.title, this.onTap, required this.loading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: CustomSize().customHeight(context)/ 20,
        width: CustomSize().customWidth(context)/4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
          color: CustomColor().customButtonColor(),
        ),
        child: Center(
          child:loading?const CircularProgressIndicator(
            color: Colors.white,
          ): Text(title,style: TextStyle(color: CustomColor().customWhiteColor(),fontSize: CustomSize().customHeight(context)/50,)),
        ),
      ),
    );
  }
}

