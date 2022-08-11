import 'package:flutter/cupertino.dart';

class Company with ChangeNotifier{
  final int companyInfoId;
  final String companyName;
  final String address;
  final String phonenumber;
  final String email;

  Company({required this.companyInfoId, required this.companyName, required this.address, required this.phonenumber, required this.email});
  

}