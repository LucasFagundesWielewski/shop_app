import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/data/store.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _email;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    if (isAuth) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (isAuth) {
      return _userId;
    }
    return null;
  }

  String? get email {
    if (isAuth) {
      return _email;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBvhsXEcNpLeGifeZKFpnyIE-wBhUtXyq0';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw Exception(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _email = responseBody['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'userId': _userId,
        'email': _email,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _userId = userData['userId'];
    _email = userData['email'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void _clearAutoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _email = null;
    _expiryDate = null;
    _clearAutoLogout();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _autoLogout() {
    _clearAutoLogout();
    final timeToLogout = _expiryDate!.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
