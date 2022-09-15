import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/shared/Config.dart';

class Auth with ChangeNotifier {
  static const _uriSignUp = "/v1/accounts:signUp";
  static const _uriSignPassword = "v1/accounts:signInWithPassword";
  String? _token;
  String? _userId;
  DateTime? _expireDate;
  Timer? _logoutTimer;

  String? get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  bool get isAuth {
    return token != null;
  }

  /**
   * Método responsável por realizar a criação do payload para login.
   */
  Map<String, Object> _createDataLogin(String email, String password) {
    return {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };
  }

  Future<void> signUp(String email, String password) async {
    final response = await _authenticate(email, password, _uriSignUp);
    return Future.value();
  }

  Future<void> login(String email, String password) async {
    final response = await _authenticate(email, password, _uriSignPassword);
    return Future.value();
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    print("userData $userData");
    if (userData.isEmpty) {
      return Future.value();
    }

    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    //
    _userId = userData['userId'];
    _token = userData['token'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer?.cancel();
      _logoutTimer = null;
    }
    Store.removeString('userData');
    notifyListeners();
  }

  Future<http.Response> _authenticate(
      String email, String password, String uri) async {
    //
    Map<String, String> params = {"key": Config.firebaseKey};
    final response = await http.post(
      Uri.https(Constantes.baseFirebaseAuth, uri, params),
      body: jsonEncode(_createDataLogin(email, password)),
    );
    final responseBody = jsonDecode(response.body);
    verifyExistErrors(responseBody);
    print("[SUCCESS] ${responseBody}");
    attrDataSession(responseBody);
    return response;
  }

  void attrDataSession(responseBody) {
    _token = responseBody["idToken"];
    _userId = responseBody["localId"];
    _expireDate = DateTime.now().add(
      Duration(seconds: int.parse(responseBody['expiresIn'])),
    );

    Store.saveMap('userData', {
      'token': _token,
      'userid': _userId,
      'expireDate': _expireDate?.toIso8601String(),
    });

    _autoLogout();
    notifyListeners();
  }

  void verifyExistErrors(dynamic responseBody) {
    if (responseBody['error'] != null) {
      print("[ERROR] founded ${responseBody['error']}");
      throw AuthException(responseBody['error']['message']);
    }
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer?.cancel();
    }
    final timeToLogout = _expireDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout!), () => logout());
  }
}
