import 'dart:convert';

import 'package:attendance_system/Models/Attendance.dart';
import 'package:attendance_system/Resources/AppUrl.dart';
import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:attendance_system/Services/ApiHandler.dart';
import 'package:attendance_system/Views/Admin/EmployeeDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Utilis/FlushBar.dart';


class ViewAttendance extends StatefulWidget {
  ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {

  final TextEditingController _search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(CustomSize().customHeight(context)/99),
              child: TextFormField(
                controller: _search,
                onChanged: (String val){
                  setState(() {});
                },
                onFieldSubmitted: (a){
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  labelText: "Employee Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CustomSize().customHeight(context)/99),
                  )
                ),
              ),
            ),
            FutureBuilder(
              future: ApiHandler().getAllEmployees(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        if(_search.text.isEmpty){
                          return GestureDetector(
                            onTap: ()async{
                              Response response=await ApiHandler().getAttendance(int.parse(snapshot.data![index].id.toString()));
                              if(context.mounted){
                                if(response.statusCode==200)
                                {
                                  dynamic obj=jsonDecode(response.body);
                                  List<Attendance> list=[];
                                  for(var i in obj)
                                  {
                                    Attendance a= Attendance(date: i["date"], attendanceStatus: i["attendance_status"], empId: i["empolyee_id"]);
                                    list.add(a);
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return EmployeesAttendanceDetail(attendanceList: list,);
                                  },));
                                }else if(response.statusCode==404){
                                  Utilis.flushBarMessage("Nothing to show", context);
                                }else{
                                  Utilis.flushBarMessage("error 500", context);
                                }
                              }
                            },
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: CustomSize().customHeight(context) / 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        CustomSize().customHeight(context) / 13),
                                    child: Image(
                                      image: NetworkImage(EndPoint.imageUrl + snapshot.data![index].profileImage),
                                      width: CustomSize().customHeight(context) / 6,
                                      height: CustomSize().customHeight(context) / 6,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                // leading: Image(image: NetworkImage(EndPoint.imageUrl+snapshot.data![index].profileImage),),
                                title: Row(
                                  children: [
                                    Text(snapshot.data![index].name),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else if(snapshot.data![index].name.toLowerCase().contains(_search.text.toString().toLowerCase())){
                          return GestureDetector(
                            onTap: ()async{
                              Response response=await ApiHandler().getAttendance(int.parse(snapshot.data![index].id.toString()));
                              if(context.mounted){
                                if(response.statusCode==200)
                                {
                                  dynamic obj=jsonDecode(response.body);
                                  List<Attendance> list=[];
                                  for(var i in obj)
                                  {
                                    Attendance a= Attendance(date: i["date"], attendanceStatus: i["attendance_status"], empId: i["empolyee_id"]);
                                    list.add(a);
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return EmployeesAttendanceDetail(attendanceList: list,);
                                  },));
                                }else if(response.statusCode==404){
                                  Utilis.flushBarMessage("Nothing to show", context);
                                }else{
                                  Utilis.flushBarMessage("error 500", context);
                                }
                              }
                            },
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: CustomSize().customHeight(context) / 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        CustomSize().customHeight(context) / 13),
                                    child: Image(
                                      image: NetworkImage(EndPoint.imageUrl + snapshot.data![index].profileImage),
                                      width: CustomSize().customHeight(context) / 6,
                                      height: CustomSize().customHeight(context) / 6,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                // leading: Image(image: NetworkImage(EndPoint.imageUrl+snapshot.data![index].profileImage),),
                                title: Row(
                                  children: [
                                    Text(snapshot.data![index].name),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final String employeeName;
  final String date;
  final String attendanceStatus;

  AttendanceItem({
    required this.employeeName,
    required this.date,
    required this.attendanceStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: CustomSize().customWidth(context) / 3,
              height: CustomSize().customWidth(context) / 15,
              child: Text(employeeName, maxLines: 2),
            ),
            SizedBox(
              width: CustomSize().customWidth(context) / 5,
              height: CustomSize().customWidth(context) / 20,
              child: Text(date),
            ),
            SizedBox(
              width: CustomSize().customWidth(context) / 5,
              height: CustomSize().customWidth(context) / 20,
              child: Text(attendanceStatus),
            ),
          ],
        ),
      ),
    );
  }
}

/*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? date = await _selectDate(context);
                  _start.text = "${date?.day}/${date?.month}/${date?.year}";
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Text("To:"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 95),
                        border: Border.all(),
                      ),
                      height: CustomSize().customHeight(context) / 20,
                      width: CustomSize().customWidth(context) / 2.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_start.text.toString()),
                          Icon(
                            Icons.calendar_month,
                            size: CustomSize().customHeight(context) / 25,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? date = await _selectDate(context);
                  _end.text = "${date?.day}/${date?.month}/${date?.year}";
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Text("From:"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            CustomSize().customHeight(context) / 95),
                        border: Border.all(),
                      ),
                      height: CustomSize().customHeight(context) / 20,
                      width: CustomSize().customWidth(context) / 2.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_end.text.toString()),
                          Icon(
                            Icons.calendar_month,
                            size: CustomSize().customHeight(context) / 25,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
StatefulBuilder(
              builder: (context, setState) {
                return FutureBuilder(
                  future: ApiHandler().getAllAttendance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Attendance> filteredData = [];
                      if (_start.text.isEmpty && _end.text.isEmpty) {
                        filteredData = snapshot.data!;
                      } else if (_start.text.isNotEmpty && _end.text.isEmpty) {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> start = _start.text.split("/");
                          int sDay = int.parse(start[0]);
                          int sMonth = int.parse(start[1]);
                          int sYear = int.parse(start[2]);
                          if (sYear <= year && sMonth <= month && sDay <= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      } else if (_start.text.isEmpty && _end.text.isNotEmpty) {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> end = _end.text.split("/");
                          int eDay = int.parse(end[0]);
                          int eMonth = int.parse(end[1]);
                          int eYear = int.parse(end[2]);
                          if (eYear >= year && eMonth >= month && eDay >= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      } else {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> start = _start.text.split("/");
                          int sDay = int.parse(start[0]);
                          int sMonth = int.parse(start[1]);
                          int sYear = int.parse(start[2]);
                          List<String> end = _end.text.split("/");
                          int eDay = int.parse(end[0]);
                          int eMonth = int.parse(end[1]);
                          int eYear = int.parse(end[2]);
                          if (eYear >= year &&
                              eMonth >= month &&
                              eDay >= day &&
                              sYear <= year &&
                              sMonth <= month &&
                              sDay <= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      }
                      return DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: filteredData.map((item) {
                            return DataRow(
                                onLongPress: () {
                                  gVal = item.attendanceStatus.toString();
                                  if (gVal == "Leave") {
                                    isLeave = true;
                                  }
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text(item.name.toString()),
                                            content: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                        value: "Present",
                                                        groupValue: gVal,
                                                        onChanged: (val) {
                                                          gVal = val.toString();
                                                          setState(() {});
                                                        }),
                                                    const Text("Present"),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: isLeave,
                                                  child: Row(
                                                    children: [
                                                      Radio(
                                                          value: "Leave",
                                                          groupValue: gVal,
                                                          onChanged: (val) {
                                                            gVal =
                                                                val.toString();
                                                            setState(() {});
                                                          }),
                                                      const Text("Leave"),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !isLeave,
                                                  child: Row(
                                                    children: [
                                                      Radio(
                                                          value: "Absent",
                                                          groupValue: gVal,
                                                          onChanged: (val) {
                                                            gVal =
                                                                val.toString();
                                                            setState(() {});
                                                          }),
                                                      const Text("Absent"),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('back'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  isLeave = !isLeave;
                                                  int code = await ApiHandler()
                                                      .updateAttendance(
                                                      item.empId,
                                                      item.date.toString(),
                                                      gVal);
                                                  if (context.mounted) {
                                                    if (code == 200) {
                                                      Navigator.pop(context);
                                                      Utilis.flushBarMessage(
                                                          "Updated Successfully",
                                                          context);
                                                    } else {
                                                      Navigator.pop(context);
                                                      Utilis.flushBarMessage(
                                                          "try again later",
                                                          context);
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                child: const Text('Update'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                cells: [
                                  DataCell(Text(item.name.toString())),
                                  DataCell(Text(item.date.toString())),
                                  DataCell(
                                      Text(item.attendanceStatus.toString()))
                                ]);
                          }).toList());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),

 */
/*
if (snapshot.hasData) {
                      List<Attendance> filteredData = [];
                      if (_start.text.isEmpty && _end.text.isEmpty) {
                        filteredData = snapshot.data!;
                      } else if (_start.text.isNotEmpty && _end.text.isEmpty) {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> start = _start.text.split("/");
                          int sDay = int.parse(start[0]);
                          int sMonth = int.parse(start[1]);
                          int sYear = int.parse(start[2]);
                          if (sYear <= year && sMonth <= month && sDay <= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      } else if (_start.text.isEmpty && _end.text.isNotEmpty) {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> end = _end.text.split("/");
                          int eDay = int.parse(end[0]);
                          int eMonth = int.parse(end[1]);
                          int eYear = int.parse(end[2]);
                          if (eYear >= year && eMonth >= month && eDay >= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      } else {
                        filteredData = snapshot.data!.where((item) {
                          List<String> date = item.date.split("/");
                          int day = int.parse(date[0]);
                          int month = int.parse(date[1]);
                          int year = int.parse(date[2]);
                          List<String> start = _start.text.split("/");
                          int sDay = int.parse(start[0]);
                          int sMonth = int.parse(start[1]);
                          int sYear = int.parse(start[2]);
                          List<String> end = _end.text.split("/");
                          int eDay = int.parse(end[0]);
                          int eMonth = int.parse(end[1]);
                          int eYear = int.parse(end[2]);
                          if (eYear >= year &&
                              eMonth >= month &&
                              eDay >= day &&
                              sYear <= year &&
                              sMonth <= month &&
                              sDay <= day) {
                            return true;
                          }
                          return false;
                        }).toList();
                      }
                      return DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: filteredData.map((item) {
                            return DataRow(
                                onLongPress: () {
                                  gVal = item.attendanceStatus.toString();
                                  if (gVal == "Leave") {
                                    isLeave = true;
                                  }
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text(item.name.toString()),
                                            content: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                        value: "Present",
                                                        groupValue: gVal,
                                                        onChanged: (val) {
                                                          gVal = val.toString();
                                                          setState(() {});
                                                        }),
                                                    const Text("Present"),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: isLeave,
                                                  child: Row(
                                                    children: [
                                                      Radio(
                                                          value: "Leave",
                                                          groupValue: gVal,
                                                          onChanged: (val) {
                                                            gVal =
                                                                val.toString();
                                                            setState(() {});
                                                          }),
                                                      const Text("Leave"),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !isLeave,
                                                  child: Row(
                                                    children: [
                                                      Radio(
                                                          value: "Absent",
                                                          groupValue: gVal,
                                                          onChanged: (val) {
                                                            gVal =
                                                                val.toString();
                                                            setState(() {});
                                                          }),
                                                      const Text("Absent"),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('back'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  isLeave = !isLeave;
                                                  int code = await ApiHandler()
                                                      .updateAttendance(
                                                      item.empId,
                                                      item.date.toString(),
                                                      gVal);
                                                  if (context.mounted) {
                                                    if (code == 200) {
                                                      Navigator.pop(context);
                                                      Utilis.flushBarMessage(
                                                          "Updated Successfully",
                                                          context);
                                                    } else {
                                                      Navigator.pop(context);
                                                      Utilis.flushBarMessage(
                                                          "try again later",
                                                          context);
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                child: const Text('Update'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                cells: [
                                  DataCell(Text(item.name.toString())),
                                  DataCell(Text(item.date.toString())),
                                  DataCell(
                                      Text(item.attendanceStatus.toString()))
                                ]);
                          }).toList());
                    }
 */