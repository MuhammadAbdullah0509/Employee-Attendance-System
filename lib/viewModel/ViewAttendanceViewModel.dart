
import 'package:attendance_system/Services/ApiHandler.dart';

import '../Models/Attendance.dart';

class ViewAttendanceViewModel{
  List<Attendance> _attendanceList=[];

  List<Attendance> get attendanceList=>_attendanceList;

  setAttendanceList()async{
    _attendanceList=await ApiHandler().getAllAttendance();
  }
}