import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetSetupAPI with ChangeNotifier {
  var _getsetup;
  String? _token;

  void update(String token) {
    _token = token;
  }

  get getsetup {
    return [..._getsetup];
  }

  getdata() async {
    var datamodel;

    try {
      var url = Uri.parse('http://api.alsmartaem.com/api/GetSetup');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        var jsonString = response.body;

        var jsonMap = json.decode(jsonString);

        datamodel = jsonMap;
      }
    } catch (Exception) {
      return datamodel;
    }

    return datamodel;
  }
}
