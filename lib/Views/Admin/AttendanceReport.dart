import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:attendance_system/Utilis/FlushBar.dart';
import 'package:attendance_system/viewModel/AdminViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/Attendance.dart';
import '../../Services/ApiHandler.dart';

class AttendanceReport extends StatefulWidget {
  AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  List<Attendance> list = [];
  final TextEditingController _start = TextEditingController();
  final TextEditingController _end = TextEditingController();
  bool isLeave = false;
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    return picked;
  }

  Future<List<Attendance>> meraFunction() async {
    List<Attendance> attendanceList = await ApiHandler().getAllAttendance();
    list = attendanceList;
    return attendanceList;
  }

  @override
  void initState() {
    // TODO: implement
    meraFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String gVal = "";
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
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
                Consumer<AdminViewModel>(
                  builder: (context, value, child) {
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
                        return
                          DataTable(
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
                                                      value.setRebuild();
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
                },)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _start.text = "";
          _end.text = "";
          setState(() {});
        },
        child: const Text("Clear"),
      ),
    );
  }
}