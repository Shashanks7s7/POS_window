

import 'package:flutter/material.dart';
import 'package:possystem/models/company.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class CompanyInfo with ChangeNotifier{
  List<Company> _contents=[];
  String? _token;
  
  void update(String token){
    _token= token;
  }
  List<Company> get contents{
    return[..._contents];
  }

  Future<void> fetchdata() async {
    
    var url= Uri.parse(
      'http://api.alsmartaem.com/api/GetCompanyInfo'
    );
   
   try{
      final response = await http.get(url,
      headers: {
        'Authorization': 'Bearer $_token'
      }
      );
    
      Map responsedata = json.decode(response.body);
      if (responsedata == null) {
        return;
      }
      final prefs = await SharedPreferences.getInstance();

    //   final List<Company> companydet=[];
    //    responsedata.forEach((index, value) {
    //     companydet.add(
    //       Company(companyInfoId:value['CompanyInfoId'],
    //        companyName: value['CompanyName'], address: value['Address'],
    //         phonenumber: value['PhoneNo'],
    //          email:value['Email'] ));
           
         
    //   });

    //  _contents=companydet;
    final companyinfo=json.encode(
      {
        'companyinfoid':responsedata['CompanyInfoID'],
        'companyname':responsedata['CompanyName'],
        'address':responsedata['Address'],
        'phoneno':responsedata['PhoneNo'],
        'email':responsedata['Email']
      }
    );
    prefs.setString('companyinfo',companyinfo);
             notifyListeners();
   }catch (error){
     rethrow;
   }
  }
}