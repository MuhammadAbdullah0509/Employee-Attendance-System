import 'dart:convert';
import 'dart:io';

import 'package:attendance_system/Views/Admin/AttendanceReport.dart';
import 'package:attendance_system/Views/Admin/OnlineEmployees.dart';
import 'package:attendance_system/Views/Admin/ViewAttendance.dart';
import 'package:attendance_system/Views/Admin/ViewLeave.dart';
import 'package:attendance_system/viewModel/AdminViewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Resources/AppUrl.dart';
import '../../Resources/CustomSize.dart';
import '../../Services/ApiHandler.dart';
import '../../Utilis/FlushBar.dart';
import '../../Utilis/Routes/RouteName.dart';

class AdminDashBoard extends StatefulWidget {
  String image;
  String name;
  String nic;
  String pId;
  String email;
  AdminDashBoard(
      {super.key,
      required this.pId,
      required this.image,
      required this.name,
      required this.nic,
      required this.email});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  void initState() {
    // TODO: implement initState
    AdminViewModel().setEmployeesCount();
    AdminViewModel().setLeaveCount();
    super.initState();
  }

  File? pickedImage;

  final imagePicker = ImagePicker();

  response() async {
    int res = await ApiHandler()
        .updateProfilePic(int.parse(widget.pId), pickedImage!);
    if (context.mounted) {
      if (res == 200) {
        Response resp =
            await ApiHandler().getUpdatedPhoto(int.parse(widget.pId));
        dynamic obj = jsonDecode(resp.body);
        widget.image = obj[0]['profile_image'].toString();
      } else {
        Utilis.flushBarMessage('try again later', context);
      }
    }
    setState(() {});
  }

  int index = 0;
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
        title: const Text("Admin"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                await getImage(ImageSource.camera);
                                response();
                              },
                              child: const Icon(Icons.camera)),
                          GestureDetector(
                              onTap: () async {
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
              padding:
                  EdgeInsets.only(left: CustomSize().customWidth(context) / 10),
              child: Text(widget.name,
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 50)),
            ),
            SizedBox(
              height: CustomSize().customHeight(context) / 90,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: CustomSize().customWidth(context) / 10),
              child: Text(widget.email,
                  style: TextStyle(
                      fontSize: CustomSize().customHeight(context) / 50)),
            ),
            GestureDetector(
              onTap: () async {
                int code = await ApiHandler().logout(int.parse(widget.pId));
                if (context.mounted) {
                  if (code == 200) {
                    Navigator.pushReplacementNamed(context, RouteName.login);
                  } else {
                    Utilis.flushBarMessage("Error", context);
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: CustomSize().customWidth(context) / 10),
                child: Row(
                  children: [
                    SizedBox(
                      height: CustomSize().customHeight(context) / 0.8,
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
      body: index == 0
          ? const OnlineEmployees()
          : index == 1
              ? const ViewLeave()
              : index == 2
                  ? AttendanceReport()
                  : ViewAttendance(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (val) {
          index = val;
          setState(() {});
        },
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        selectedIconTheme: const IconThemeData(color: Colors.teal),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Consumer<AdminViewModel>(
                builder: (BuildContext context, AdminViewModel value, Widget? child)
                {
                  return Badge(
                      label: Text(value.employeesCount.toString()),
                      child:const Icon(Icons.person_4_outlined));
                },
              ), label: 'Online Employees'),
          BottomNavigationBarItem(
              icon: Consumer<AdminViewModel>(
                builder: (context, value, child) {
                  return Badge(
                      label: Text(value.leaveCount.toString()),
                      child:const Icon(Icons.book));
                },
              ), label: 'Leave'),
         const BottomNavigationBarItem(
              icon: Icon(Icons.collections), label: 'Attendance Report'),
         const BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Attendance'),
        ],
      ),
    );
  }
}
