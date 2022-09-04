import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/const/constantes.dart';

class Auth with ChangeNotifier {
  static const _keyApp = 'AIzaSyC7-__gzRJWSZvaCqSOU8x_HM8_nxhG7k4';
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

    print(jsonDecode(response.body));
    return Future.value();
  }

  Future<http.Response> _authenticate(
      String email, String password, String uri) async {
    Map<String, String> params = {"key": _keyApp};
    return await http.post(
      Uri.https(Constantes.baseFirebaseAuth, uri, params),
      body: jsonEncode(_createDataLogin(email, password)),
    );
  }
}
