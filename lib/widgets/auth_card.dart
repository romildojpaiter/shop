import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final _passwordControler = TextEditingController();
  final Map<String, String> _authData = {'email': '', 'password': ''};

  void _showErrorDialog(String mensagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Ocorreu um erro"),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (checkSignup) {
        print('Registra');
        await auth
            .signUp(_authData['email']!, _authData['password']!)
            .then((value) => setState(() {
                  _isLoading = false;
                }));
      } else {
        print('Login');
        await auth
            .login(_authData['email']!, _authData['password']!)
            .then((value) => setState(() {
                  _isLoading = false;
                }));
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (checkSignup) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: checkSignup ? 370 : 310,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text('E-mail')),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return "Informe um e-mail válido";
                  }
                  return null;
                },
                onSaved: (newValue) => _authData['email'] = newValue!,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Senha')),
                controller: _passwordControler,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return "Informe uma senha válida!";
                  }
                  return null;
                },
                onSaved: (newValue) => _authData['password'] = newValue!,
              ),
              if (checkSignup)
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(label: Text('Confirmar Senha')),
                  validator: checkSignup
                      ? (value) {
                          if (value != _passwordControler.text) {
                            return "Senhas são diferente!";
                          }
                          return null;
                        }
                      : null,
                  onSaved: (newValue) => _authData['password'] = newValue!,
                ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  child: Text(checkSignup ? 'REGISTRAR' : 'ENTRAR'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _submit,
                ),
              if (!_isLoading)
                TextButton(
                  onPressed: _switchAuthMode,
                  child:
                      Text("ALTERAR P/ ${checkSignup ? 'LOGIN' : 'REGISTRAR'}"),
                )
            ],
          ),
        ),
      ),
    );
  }

  bool get checkSignup => _authMode == AuthMode.Signup;
}
