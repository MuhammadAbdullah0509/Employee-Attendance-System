
import 'package:attendance_system/Services/ApiHandler.dart';
import 'package:flutter/cupertino.dart';

class AdminViewModel with ChangeNotifier{
  int _employeesCount=0;

  get employeesCount=>_employeesCount;

 setEmployeesCount()async
 {
   _employeesCount=await ApiHandler().getOnlineEmployeesCount();
   notifyListeners();
 }

  int _leaveCount=0;

  get leaveCount=>_leaveCount;

  setLeaveCount()async
  {
    _leaveCount=await ApiHandler().getLeaveCount();
    notifyListeners();
  }
  setRebuild(){
    notifyListeners();
  }
}
