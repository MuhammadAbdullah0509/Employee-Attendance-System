import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  CustomContainer({super.key,required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(CustomSize().customHeight(context)/70),
      child: GestureDetector(
        onTap: ()=>onTap,
        child: Container(
          height: CustomSize().customHeight(context)/10,
          width: CustomSize().customWidth(context)/2,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
          ),
          child: Center(
            child: Text(title,style: TextStyle(fontSize: CustomSize().customHeight(context)/50),),
          ),
        ),
      ),
    );
  }
}
