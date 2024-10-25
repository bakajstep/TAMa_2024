import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirst_quest/api/api_client.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/states/models/identity.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiClient = ApiClient(baseUrl: 'http://localhost:8080');
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await _apiClient.login(
        _usernameController.text, _passwordController.text);

    if (!mounted) {
      return;
    }

    if (response == null) {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
      return;
    }

    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.login(Identity(
        id: response.user.id,
        email: response.user.email,
        username: response.user.username,
        roles: response.roles));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token);

    if (!mounted) {
      return;
    }

    // If the form is valid, navigate to the home page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Title'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Login Page', style: TextStyle(fontSize: 25)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
                if (_errorMessage != null)
                  Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error,
                              color: Theme.of(context).colorScheme.error),
                          Text(_errorMessage!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error)),
                        ]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20.0))
                  ]),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter your password'
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
