class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Este endereço de e-mail já está em uso.',
    'OPERATION_NOT_ALLOWED':
        'O login com senha está desativado para este projeto.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Bloqueamos todas as solicitações deste dispositivo devido a atividade incomum. Tente novamente mais tarde.',
    'EMAIL_NOT_FOUND': 'Este endereço de e-mail não está registrado.',
    'INVALID_PASSWORD': 'A senha é inválida.',
    'USER_DISABLED': 'A conta do usuário foi desativada por um administrador.',
    'USER_NOT_FOUND': 'A conta do usuário não foi encontrada.',
    'WEAK_PASSWORD': 'A senha é muito fraca.',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro na autenticação.';
  }
}
