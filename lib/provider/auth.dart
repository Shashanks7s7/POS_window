import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? userId;
  DateTime? _expirytime;
  String? _token;
  Timer? authTimer;
  bool get authd {
    return token != null;
  }

  String? get token {
    if (_expirytime != null &&
        _expirytime!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userid {
    return userId;
  }

  Future<void> authenticate(
      String clientid, String username, String password) async {
    final Uri url = Uri.http('api.alsmartaem.com',
        '/token'); // Uri.parse('http://api.alsmartaem.com/token');

    try {
      final response = await http.post(
        url,
        body: {
          'ClientID': clientid,
          'grant_type': 'password',
          'username': username,
          'password': password,
          'product_name': 'cust_inv'
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
      );

      Map responsedata = json.decode(response.body);

      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['access_token'];

      _expirytime = DateTime.now().add(
          Duration(seconds: int.parse(responsedata['expires_in'].toString())));

      autologout();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode(
          {'token': _token, 'expirydata': _expirytime!.toIso8601String()});
      prefs.setString('userdata', userdata);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(
    String clientid,
    String username,
    String password,
  ) async {
    return authenticate(clientid, username, password);
  }

  Future<bool> tryautologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final extracteddata = json.decode(prefs.getString("userdata").toString())
        as Map<String, dynamic>;

    final expire = DateTime.parse(extracteddata['expirydata'].toString());

    if (expire.isBefore(DateTime.now())) {
      return false;
    }

    _token = extracteddata['token'].toString();
    userId = extracteddata['userid'].toString();
    _expirytime = expire;
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    userId = null;
    _expirytime = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userdata');
  }

  void autologout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final timetoExpiry = _expirytime!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}
