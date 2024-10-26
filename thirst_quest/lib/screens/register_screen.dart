import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/widgets/form_error.dart';
import 'package:thirst_quest/widgets/loading.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ValueNotifier<String?> _confirmPasswordError =
      ValueNotifier<String?>(null);
  final _authService = AuthService();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_validateConfirmPassword);
    _passwordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateConfirmPassword() {
    _confirmPasswordError.value = _confirmPasswordController.text != '' &&
            _confirmPasswordController.text != _passwordController.text
        ? 'Passwords do not match'
        : null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() ||
        _confirmPasswordError.value != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final globalState = Provider.of<GlobalState>(context, listen: false);
    final response = await _authService.register(_emailController.text,
        _usernameController.text, _passwordController.text, globalState);

    if (response == null) {
      setState(() {
        _errorMessage = 'User with given email/username already exists';
        _isLoading = false;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Stack(children: [
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Register Page', style: TextStyle(fontSize: 25)),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0)),
                    FormError(errorMessage: _errorMessage),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your username'
                          : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your email'
                          : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your password'
                          : null,
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: _confirmPasswordError,
                      builder: (context, errorText, child) {
                        return TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            errorText: errorText,
                          ),
                          obscureText: true,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please confirm your password'
                              : null,
                        );
                      },
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0)),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const Loading(),
        ]));
  }
}
