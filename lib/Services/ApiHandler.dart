
import 'dart:convert';
import 'dart:io';
import 'package:attendance_system/Models/Attendance.dart';
import 'package:attendance_system/Models/Employee.dart';
import 'package:attendance_system/Models/Leave.dart';
import 'package:attendance_system/Resources/AppUrl.dart';
import 'package:http/http.dart'as http;


class ApiHandler{

  Future<int> logout(int id)async
  {
    String apiEndPoint=EndPoint.logout+"?id=$id";
    Uri uri= Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }
  Future<http.Response> login(String name, String password)async
 {
     String apiEndPoint=EndPoint.login+"?email=$name&password=$password";
     Uri uri= Uri.parse(apiEndPoint);
     var response=await http.get(uri);
     return response;
 }
 Future<int> createAccount(String name, String password,String email,File image, String nic)async{
   String apiEndPoint=EndPoint.signUp;
   Uri url = Uri.parse(apiEndPoint);
   http.MultipartRequest request = http.MultipartRequest('POST', url);
   request.fields["name"] = name;
   request.fields["password"] = password;
   request.fields["email"] = email;
   request.fields["nic"] = nic;
   http.MultipartFile imageFile =
   await http.MultipartFile.fromPath("image", image.path);
   request.files.add(imageFile);
   var response = await request.send();
   return response.statusCode;
 }

 Future<int> updateProfilePic(int id,File image)async
 {
   String apiEndPoint=EndPoint.updateProfileImage;
   Uri url = Uri.parse(apiEndPoint);
   http.MultipartRequest request = http.MultipartRequest('POST', url);
   request.fields["id"] = id.toString();
   http.MultipartFile imageFile =
       await http.MultipartFile.fromPath("image", image.path);
   request.files.add(imageFile);
   var response = await request.send();
   return response.statusCode;

 }
  Future<http.Response> getUpdatedPhoto(int id)async
  {
    String apiEndPoint="${EndPoint.updatedPhoto}?id=$id";
    Uri uri= Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    return response;
  }
  Future<int> markAttendance(int id, String status)async
  {
    DateTime now = DateTime.now();
    String date="${now.day}/${now.month}/${now.year}";
    String apiEndPoint="${EndPoint.markAttendance }?id=$id&status=$status&date=$date";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }
  Future<int> markLeave(int id,String reason)async
  {
    DateTime now = DateTime.now();
    String date = "${now.day}/${now.month}/${now.year}";
    String apiEndPoint = "${EndPoint
        .markLeave }?id=$id&reason=$reason&date=$date";
    Uri uri = Uri.parse(apiEndPoint);
    var response = await http.post(uri);
    return response.statusCode;
  }
  Future<http.Response> getAttendance(int id)async
  {
    String apiEndPoint="${EndPoint.getAttendance}?id=$id";
    Uri uri=Uri.parse(apiEndPoint);
    var response= await http.get(uri);
    return response;
  }
  Future<List<String>> getOnlineEmployees()async{
    List<String> name=[];
    String apiEndPoint=EndPoint.getOnlineStudent;
    Uri uri=Uri.parse(apiEndPoint);
    var response= await http.get(uri);
    dynamic body=jsonDecode(response.body);
    for(var i in body)
    {
      name.add(i["name"].toString());
    }
    return name;
  }
  Future<int> getOnlineEmployeesCount()async
  {
    List<String> count=await getOnlineEmployees();
    return count.length;
  }
  Future<List<Leave>> getLeave()async
  {
    List<Leave> list=[];
    String apiEndPoint=EndPoint.getLeaveApplications;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    dynamic obj=jsonDecode(response.body);
    Leave l;
    for(var i in obj)
    {
      l= Leave(id: i["empolyee_id"], name: i["name"],date: i["date"]);
      list.add(l);
    }
    return list;
  }
  Future<int> getLeaveCount()async
  {
    List<Leave> count=await getLeave();
    return count.length;
  }

  Future<int> leaves(int id, String status,String date)async{
    String apiEndPoint=EndPoint.leaves+"?id=$id&status=$status&date=$date";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }
  Future<List<Attendance>> getAllAttendance()async
  {
    List<Attendance> list=[];
    String apiEndPoint=EndPoint.getAllAttendance;
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.get(uri);
    dynamic obj=jsonDecode(response.body);
    for(var i in obj)
    {
      Attendance a= Attendance(date: i["date"],image: i["profile_image"] ,attendanceStatus: i["attendance_status"], name: i["name"],empId: i["empolyee_id"]);
      list.add(a);
    }

    return list;
  }
  Future<int> updateAttendance(int id,String date,String status)async{
    String apiEndPoint="${EndPoint.updateAttendance}?id=$id&date=$date&status=$status";
    Uri uri=Uri.parse(apiEndPoint);
    var response=await http.post(uri);
    return response.statusCode;
  }
  Future<List<Employee>> getAllEmployees()async{
    List<Employee> employeeList=[];
    String apiEndPoint=EndPoint.getAllEmployees;
    Uri uri=Uri.parse(apiEndPoint);
    var response= await http.get(uri);
    if(response.statusCode==200)
    {
      dynamic obj=jsonDecode(response.body);
      for(var i in obj)
      {
        Employee emp= Employee(name: i["name"], id: i["id"], profileImage: i["profile_image"]);
        employeeList.add(emp);
      }
      return employeeList;
    }else
    {
      return employeeList;
    }
  }
}