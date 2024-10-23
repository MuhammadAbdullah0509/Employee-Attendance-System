
class Attendance
{
  int? id;
  int empId;
  String date;
  String? image;
  String? name;
  String attendanceStatus;

  Attendance({this.id,required this.date,required this.attendanceStatus,required this.empId,this.name,this.image});

  Map<String,dynamic> toMap()
  {
    return {
      "id":id,
      "empId":empId,
      "date":date,
      "attendanceStatus":attendanceStatus,
    };
  }
  Attendance.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        date = res['date'],
        empId = int.parse(res['empId'].toString()),
        attendanceStatus=res['attendanceStatus'];
}