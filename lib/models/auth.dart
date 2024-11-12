import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  static const url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBvhsXEcNpLeGifeZKFpnyIE-wBhUtXyq0';
  Future<void> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }
}
