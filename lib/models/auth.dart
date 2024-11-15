import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String? _token;
  String? _uid;
  String? _email;
  DateTime? _expiryDate;

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

  String? get uid {
    if (isAuth) {
      return _uid;
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
      _uid = responseBody['localId'];
      _email = responseBody['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
