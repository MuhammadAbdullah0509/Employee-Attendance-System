
import 'package:attendance_system/Resources/CustomSize.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ViewAttendance extends StatefulWidget {

  dynamic attendanceList;
  ViewAttendance({super.key, required this.attendanceList});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  @override
  int present=0;
  int absent=0;
  int leave=0;
  @override
  void initState() {
    // TODO: implement initState
    for(int index=0;index<widget.attendanceList.length;index++)
    {
      if(widget.attendanceList[index]["attendance_status"]=="Present")
      {
        present++;
      }else if(widget.attendanceList[index]["attendance_status"]=="Absent")
      {
        absent++;
      }else if(widget.attendanceList[index]["attendance_status"]=="Leave" ||
          widget.attendanceList[index]["attendance_status"]=="Pending" ||widget.attendanceList[index]["attendance_status"]=="Rejected")
      {
        leave++;
      }
    }
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Attendance Record"),centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(CustomSize().customHeight(context) / 80),
        child: Column(
          children: [
            PieChart(
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
            const Card(
              child: ListTile(
                title:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("    Date"),
                    Text("Attendance Status"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.attendanceList.length,
                itemBuilder: (context, index) {
                    return Card(
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
