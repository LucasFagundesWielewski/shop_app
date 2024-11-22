import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/exceptions/auth_exception.dart';
import 'package:shop_app/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMode authMode = AuthMode.Login;
  final Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<Size>? heightAnimation;

  bool isLogin() => authMode == AuthMode.Login;
  bool isSignup() => authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    heightAnimation = Tween<Size>(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    //heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void switchAuthMode() {
    setState(() {
      if (isLogin()) {
        authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> submit() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => isLoading = true);

    formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (isLogin()) {
        // Login
        await auth.login(authData['email'] ?? '', authData['password'] ?? '');
      } else {
        // Signup
        await auth.signup(authData['email'] ?? '', authData['password'] ?? '');
      }
    } on AuthException catch (error) {
      showErrorDialog(error.toString());
    } catch (error) {
      showErrorDialog('Ocorreu um erro inesperado');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        padding: const EdgeInsets.all(16),
        //height: isLogin() ? 310 : 400,
        //height: heightAnimation?.value.height ?? (isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => authData['email'] = email ?? '',
                // ignore: no_leading_underscores_for_local_identifiers
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSaved: (password) => authData['password'] = password ?? '',
                controller: passwordController,
                // ignore: no_leading_underscores_for_local_identifiers
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.trim().isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: isLogin()
                      ? null
                      // ignore: no_leading_underscores_for_local_identifiers
                      : (_password) {
                          final password = _password ?? '';
                          if (password != passwordController.text) {
                            return 'Senhas não conferem';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: switchAuthMode,
                child: Text(
                  isLogin() ? 'REGISTRAR-SE' : 'JÁ POSSUI UMA CONTA? ENTRAR',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
