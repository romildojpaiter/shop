class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail existente",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Você já realizou muitas tentativas, tente daqui um pouco",
    "INVALID_CUSTOM_TOKEN": "Token inválido",
    "CREDENTIAL_MISMATCH": "Credencial inválida",
    "TOKEN_EXPIRED": "Sessão expiradas",
    "USER_DISABLED": "Usuário desabilitado",
    "USER_NOT_FOUND": "Usuário não encontrado"
  };
  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key]!;
    }
    return "Ocorreu um erro na autenticação";
  }
}
