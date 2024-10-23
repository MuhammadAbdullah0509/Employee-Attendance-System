
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../Models/Attendance.dart';
import '../../Resources/CustomSize.dart';
import '../../Services/ApiHandler.dart';
import '../../Utilis/FlushBar.dart';

class EmployeesAttendanceDetail extends StatefulWidget {

  List<Attendance> attendanceList;
  EmployeesAttendanceDetail({super.key,required this.attendanceList});

  @override
  State<EmployeesAttendanceDetail> createState() => _EmployeesAttendanceDetailState();
}

class _EmployeesAttendanceDetailState extends State<EmployeesAttendanceDetail> {
  int present=0;
  int absent=0;
  int leave=0;
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
    meraFunction();
    // TODO: implement initState
    for(int index=0;index<widget.attendanceList.length;index++)
    {
      if(widget.attendanceList[index].attendanceStatus=="Present")
      {
        present++;
      }else if(widget.attendanceList[index].attendanceStatus=="Absent")
      {
        absent++;
      }else if(widget.attendanceList[index].attendanceStatus=="Leave" ||
          widget.attendanceList[index].attendanceStatus=="Pending" ||widget.attendanceList[index].attendanceStatus=="Rejected")
      {
        leave++;
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String gVal = "";
    return Scaffold(
      appBar: AppBar(title:const Text("Attendance Record"),centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(CustomSize().customHeight(context) / 80),
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
            Padding(
              padding: EdgeInsets.all(CustomSize().customHeight(context)/100),
              child: PieChart(
//                centerText: widget.attendanceList.name.toString(),
                legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.left),
                dataMap: {
                  'present':present.toDouble(),
                  'Absent':absent.toDouble(),
                  'Leave':leave.toDouble(),
                },
                chartRadius: MediaQuery.of(context).size.width / 3,
                chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true),
                animationDuration: const Duration(milliseconds: 1000),
                chartType: ChartType.ring,
                colorList: const [Colors.green, Colors.red,Colors.blue],
              ),
            ),
            Expanded(
              child: StatefulBuilder(
                builder: (context, setState) {
                  List<Attendance> filteredData = [];
                  if (_start.text.isEmpty && _end.text.isEmpty) {
                    filteredData = widget.attendanceList;
                  } else if (_start.text.isNotEmpty && _end.text.isEmpty) {
                    filteredData = widget.attendanceList.where((item) {
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
                    filteredData = widget.attendanceList.where((item) {
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
                    filteredData = widget.attendanceList.where((item) {
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
                  return SizedBox(
                    width: CustomSize().customWidth(context)/1.3,
                    child: DataTable(
                        columns: const [
                       //   DataColumn(label: Text("Name")),
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
                         //       DataCell(Text(item.name.toString())),
                                DataCell(Text(item.date.toString())),
                                DataCell(
                                    Text(item.attendanceStatus.toString()))
                              ]);
                        }).toList()),
                  );
                },
              ),
            ),
          ],
        ),
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
/*            Expanded(
              child: ListView.builder(
                itemCount: widget.attendanceList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){},
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.attendanceList[index]["date"].toString()),
                            Text(widget.attendanceList[index]["attendance_status"]
                                .toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )*/

/*
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
 */