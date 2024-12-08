import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:thirst_quest/assets/thirst_quest_icons.dart';
import 'package:thirst_quest/di.dart';
import 'package:thirst_quest/screens/profile_screen.dart';
import 'package:thirst_quest/screens/register_screen.dart';
import 'package:thirst_quest/services/auth_service.dart';
import 'package:thirst_quest/states/global_state.dart';
import 'package:thirst_quest/widgets/form_error.dart';
import 'package:thirst_quest/widgets/loading.dart';
import 'package:thirst_quest/widgets/sign_in_button.dart';
import 'package:thirst_quest/assets/constants.dart' as constants;

class LoginScreen extends StatefulWidget {
  final MaterialPageRoute? onLoginSuccess;
  final bool popOnSuccess;

  const LoginScreen({this.onLoginSuccess, this.popOnSuccess = false, super.key});

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

    _authService.googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
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
    final response = await _authService.login(_emailController.text, _passwordController.text, globalState);

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
    _redirectAfterLogin();
  }

  // Used to sign in with Google (for android)
  Future _signInWithGoogleButton() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _authService.googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

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
    _redirectAfterLogin();
  }

  void _redirectAfterLogin() {
    if (widget.popOnSuccess) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
        context, widget.onLoginSuccess ?? MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                Icon(ThirstQuestIcons.thirstQuest, color: Colors.indigo, size: 70,),
                const SizedBox(height: 10,),
                const Text('Welcome to ${constants.appName}!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Log in to your account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 15),
                      FormError(errorMessage: _errorMessage),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter your email' : null,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter your password' : null,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Log in'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.withOpacity(0.9))),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or', style: TextStyle(color: Colors.grey))),
                              Expanded(child: Divider(color: Colors.grey.withOpacity(0.9)))
                            ],
                          ),
                      ),
                      buildSignInButton(
                        onPressed: _signInWithGoogleButton,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text('Don\'t have an account yet?', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(onLoginSuccess: widget.onLoginSuccess, popOnSuccess: widget.popOnSuccess))),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.indigo.shade800,
                    textStyle: TextStyle(fontSize: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Register'),
                )
              ]
            ),
          ),
        ),
        if (_isLoading) const Loading(),
      ]),
    );
  }
}
