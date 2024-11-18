import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/profile_screen.dart';
import 'package:thirst_quest/screens/screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/widgets/form_error.dart';
import 'package:thirst_quest/widgets/loading.dart';
import 'package:thirst_quest/widgets/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = DI.get<AuthService>();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _authService.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      if (account == null) return;

      setState(() {
        _isLoading = true;
      });

      final googleAuth = await account.authentication;
      await _signInWithGoogle(googleAuth);
    });

    _authService.googleSignIn.signInSilently(reAuthenticate: true);
  }

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

    setState(() {
      _isLoading = true;
    });

    final globalState = Provider.of<GlobalState>(context, listen: false);
    final response = await _authService.login(
        _emailController.text, _passwordController.text, globalState);

    if (!mounted) {
      return;
    }

    if (response == null) {
      setState(() {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
      });
      return;
    }

    // If the form is valid, navigate to the home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  // Used to sign in with Google (for android)
  Future _signInWithGoogleButton() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser =
          await _authService.googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      await _signInWithGoogle(googleAuth);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _signInWithGoogle(GoogleSignInAuthentication googleAuth) async {
    if (!mounted) {
      return;
    }

    final idToken = googleAuth.idToken;
    if (idToken == null) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google';
        _isLoading = false;
      });
      return;
    }

    final globalState = Provider.of<GlobalState>(context, listen: false);
    final response = await _authService.signInWithGoogle(idToken, globalState);

    if (!mounted) {
      return;
    }

    if (response == null) {
      setState(() {
        _errorMessage = 'Given google email is already registered';
        _isLoading = false;
      });
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
      body: Stack(children: [
        Center(
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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
                  buildSignInButton(
                    onPressed: _signInWithGoogleButton,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const Loading(),
      ]),
    );
  }
}
