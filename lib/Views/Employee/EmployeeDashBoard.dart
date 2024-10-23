
import 'dart:convert';
import 'dart:io';

import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:attendance_system/Services/ApiHandler.dart';
import 'package:attendance_system/Utilis/FlushBar.dart';
import 'package:attendance_system/Utilis/Routes/RouteName.dart';
import 'package:attendance_system/Views/Employee/ViewAttendance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../Resources/AppUrl.dart';

class EmployeeDashBoard extends StatefulWidget {
  String image;
  String name;
  String nic;
  String pId;
  String email;

  EmployeeDashBoard(
      {super.key,
      required this.email,
      required this.image,
      required this.nic,
      required this.pId,
      required this.name});

  @override
  State<EmployeeDashBoard> createState() => _EmployeeDashBoardState();
}

class _EmployeeDashBoardState extends State<EmployeeDashBoard> {
  File? pickedImage;

  final imagePicker = ImagePicker();

  response()async{
    int res=await ApiHandler().updateProfilePic(int.parse(widget.pId), pickedImage!);
    if(context.mounted)
    {
      if(res==200)
      {
        Response resp=await ApiHandler().getUpdatedPhoto(int.parse(widget.pId));
        dynamic obj=jsonDecode(resp.body);
        widget.image=obj[0]['profile_image'].toString();
      }else{
        Utilis.flushBarMessage('try again later', context);
      }
      Navigator.of(context).pop();
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Future<void> getImage(ImageSource source) async {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image != null) {
        pickedImage = File(image.path);
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text("EziTech Institute"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: (){
                showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () async{
                                await getImage(ImageSource.camera);
                                response();
                              },
                              child: const Icon(Icons.camera_alt)),
                          GestureDetector(
                              onTap: () async{
                                await getImage(ImageSource.gallery);
                                response();
                              },
                              child: const Icon(Icons.photo))
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: CustomSize().customHeight(context) / 13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      CustomSize().customHeight(context) / 13),
                  child: Image(
                    image: NetworkImage(EndPoint.imageUrl + widget.image),
                    width: CustomSize().customHeight(context) / 6,
                    height: CustomSize().customHeight(context) / 6,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: CustomSize().customHeight(context) / 90,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: CustomSize().customWidth(context)/10
              ),
              child: Text(widget.name,
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 50)),
            ),
            SizedBox(
              height: CustomSize().customHeight(context) / 90,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: CustomSize().customWidth(context)/10
              ),
              child: Text(widget.email,
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 50)),
            ),
            GestureDetector(
              onTap: ()async{
                int code=await ApiHandler().logout(int.parse(widget.pId));
                if(context.mounted)
                {
                  if(code==200)
                  {
                    Navigator.pushReplacementNamed(context, RouteName.login);
                  }else
                  {
                    Utilis.flushBarMessage("Error", context);
                  }
                }
              },
              child:Padding(
                padding: EdgeInsets.only(
                    left: CustomSize().customWidth(context)/10
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: CustomSize().customHeight(context)/0.8,
                    ),
                    const Text("Logout"),
                    const Icon(Icons.logout)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(CustomSize().customHeight(context)/70),
              child: GestureDetector(
                onTap: ()async{
                  int statusCode=await ApiHandler().markAttendance(int.parse(widget.pId), "Present");
                  if(context.mounted)
                  {
                    if(statusCode==200)
                    {
                      Utilis.flushBarMessage("Marked", context);
                    }else if(statusCode==500){
                      Utilis.flushBarMessage("error 500", context);
                    }else{
                      Utilis.flushBarMessage("Already Marked", context);
                    }
                  }
                },
                child: Container(
                  height: CustomSize().customHeight(context)/10,
                  width: CustomSize().customWidth(context)/2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
                  ),
                  child: Center(
                    child: Text("Present",style: TextStyle(fontSize: CustomSize().customHeight(context)/50),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(CustomSize().customHeight(context)/70),
              child: GestureDetector(
                onTap: ()async{
                  int statusCode=await ApiHandler().markAttendance(int.parse(widget.pId), "Pending");
                  if(context.mounted)
                  {
                    if(statusCode==200)
                    {
                      Utilis.flushBarMessage("Marked", context);
                    }else if(statusCode==500){
                      Utilis.flushBarMessage("error 500", context);
                    }else if(statusCode==302){
                      Utilis.flushBarMessage("Attendance already Marked", context);
                    }else{
                      Utilis.flushBarMessage("Already Marked", context);
                    }
                  }
                },
                child: Container(
                  height: CustomSize().customHeight(context)/10,
                  width: CustomSize().customWidth(context)/2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
                  ),
                  child: Center(
                    child: Text("Leave",style: TextStyle(fontSize: CustomSize().customHeight(context)/50),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(CustomSize().customHeight(context)/70),
              child: GestureDetector(
                onTap: ()async{
                  Response response=await ApiHandler().getAttendance(int.parse(widget.pId));
                  if(context.mounted){
                    if(response.statusCode==200)
                    {
                      dynamic obj=jsonDecode(response.body);
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ViewAttendance(attendanceList: obj,);
                      },));
                    }else if(response.statusCode==404){
                      Utilis.flushBarMessage("Nothing to show", context);
                    }else{
                      Utilis.flushBarMessage("error 500", context);
                    }
                  }
                },
                child: Container(
                  height: CustomSize().customHeight(context)/10,
                  width: CustomSize().customWidth(context)/2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/90),
                  ),
                  child: Center(
                    child: Text("View Attendance",style: TextStyle(fontSize: CustomSize().customHeight(context)/50),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
