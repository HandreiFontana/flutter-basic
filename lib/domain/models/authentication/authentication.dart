import 'dart:async';
import 'dart:convert';

import 'package:basic/data/store.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  String? _token;
  String? _login;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get loginField {
    return isAuth ? _login : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
    String login,
    String password,
    String urlFragment,
  ) async {
    const url = '${AppConstants.apiUrl}/sessions';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': login,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw AuthException(body['message']);
    } else {
      _token = body['token'];
      _login = body['user']['login'];
      _userId = body['user']['login'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse('28800'),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'login': _login,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String login, String password) async {
    return _authenticate(login, password, 'signUp');
  }

  Future<void> login(String login, String password) async {
    return _authenticate(login, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _login = userData['login'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _login = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
