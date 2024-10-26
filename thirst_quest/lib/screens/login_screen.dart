import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/widgets/form_error.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final globalState = Provider.of<GlobalState>(context, listen: false);
    final response = await _authService.login(
        _emailController.text, _passwordController.text, globalState);

    if (!mounted) {
      return;
    }

    if (response == null) {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    // If the form is valid, navigate to the home page
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
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Login Page', style: TextStyle(fontSize: 25)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                FormError(errorMessage: _errorMessage),
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
                const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
