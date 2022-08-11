class LnUser {
  bool? success;
  String? message;
  Data? data;

  LnUser({this.success, this.message, this.data});

  LnUser.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Success'] = success;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? username;
  int? userGroupID;
  String? userGroupName;
  int? employeeID;
  Null? empCode;
  Null? firstName;
  Null? middleName;
  Null? lastName;
  Null? email;

  Data(
      {this.userId,
      this.username,
      this.userGroupID,
      this.userGroupName,
      this.employeeID,
      this.empCode,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    username = json['Username'];
    userGroupID = json['UserGroupID'];
    userGroupName = json['UserGroupName'];
    employeeID = json['EmployeeID'];
    empCode = json['EmpCode'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UserId'] = userId;
    data['Username'] = username;
    data['UserGroupID'] = userGroupID;
    data['UserGroupName'] = userGroupName;
    data['EmployeeID'] = employeeID;
    data['EmpCode'] = empCode;
    data['FirstName'] = firstName;
    data['MiddleName'] = middleName;
    data['LastName'] = lastName;
    data['Email'] = email;
    return data;
  }
}