

class EndPoint{
  static String baseUrl="http://192.168.10.9/AttendanceManagmentSystemApi/";
  static String login=baseUrl+"api/User/Login";
  static String logout=baseUrl+"api/User/Logout";
  static String signUp=baseUrl+"api/User/createAccount";
  static String imageUrl=baseUrl+"Content/profileImages/";
  static String updateProfileImage=baseUrl+"api/Employee/UpdateProfileImage";
  static String updatedPhoto=baseUrl+"api/Employee/GetPhoto";
  static String markAttendance=baseUrl+"api/Employee/MarkAttendance";
  static String markLeave=baseUrl+"api/Employee/MarkLeave";
  static String getAttendance=baseUrl+"api/Employee/GetAttendance";
  static String getOnlineStudent=baseUrl+"api/Employee/GetOnlineEmployees";
  static String getLeaveApplications=baseUrl+"/api/Employee/GetLeave";
  static String leaves=baseUrl+"/api/Employee/Leaves";
  static String getAllAttendance=baseUrl+"/api/Employee/GetAllAttendance";
  static String updateAttendance=baseUrl+"/api/Employee/UpdateAttendance";
  static String getAllEmployees=baseUrl+"/api/Employee/getAllEmployees";
}