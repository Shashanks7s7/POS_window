import 'package:flutter/material.dart';
import 'package:possystem/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:possystem/models/ln_user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class LoggedInUser with ChangeNotifier{
  List<Company> _userdata=[];
  String? _token;
  
  void update(String token){
    _token= token;
  }
  List<Company> get userdata{
    return[..._userdata];
  }
 
  Future<void> fetchdata() async {
    
    var url= Uri.parse(
      'http://api.alsmartaem.com/api/GetLogedInUserInfo'
    );
   
   try{
      final response = await http.get(url,
      headers: {
        'Authorization': 'Bearer $_token'
      }
      );
      
      var responsedata = json.decode(response.body);
      
      var data=LnUser.fromJson(responsedata);
     
      if (responsedata == null) {
        return;
      }
      final prefs = await SharedPreferences.getInstance();

     final loginuserinfo=json.encode(
       {
         "Success": data.success,
         "Message": data.message,
  
          "UserId": data.data!.userId,
          "Username": data.data!.username,
          "UserGroupID": data.data!.userGroupID,
         "UserGroupName": data.data!.userGroupName,
          "EmployeeID": data.data!.employeeID,
         "EmpCode": data.data!.empCode,
         "FirstName":  data.data!.firstName,
         "MiddleName":  data.data!.middleName,
          "LastName":  data.data!.lastName,
          "Email":  data.data!.email
       }
     );
     prefs.setString('loggedinuserinfo',loginuserinfo);
     
             notifyListeners();
   }catch (error){
     rethrow;
   }
  }
}