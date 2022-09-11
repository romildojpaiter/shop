import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';
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

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer?.cancel();
      _logoutTimer = null;
    }
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
