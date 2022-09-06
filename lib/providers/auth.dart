import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/shared/Config.dart';

class Auth with ChangeNotifier {
  static const _uriSignUp = "/v1/accounts:signUp";
  static const _uriSignPassword = "v1/accounts:signInWithPassword";
  // "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${_keyApp}";

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

    print(jsonDecode(response.body));
    return Future.value();
  }

  Future<void> login(String email, String password) async {
    final response = await _authenticate(email, password, _uriSignPassword);

    final responseBody = jsonDecode(response.body);

    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    }

    return Future.value();
  }

  Future<http.Response> _authenticate(
      String email, String password, String uri) async {
    Map<String, String> params = {"key": Config.firebaseKey};
    return await http.post(
      Uri.https(Constantes.baseFirebaseAuth, uri, params),
      body: jsonEncode(_createDataLogin(email, password)),
    );
  }
}
