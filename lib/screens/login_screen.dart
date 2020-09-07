import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  String errorMessage;

  void _signInWithGoogle () async{
    _setLoggingIn();
    String errMsg;

    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,);

      await _auth.signInWithCredential(credential);
    } catch (e) {
      errMsg = 'Login failed, Please try again later.';
    } finally {
      _setLoggingIn(false, errMsg);
    }
  }

  void _setLoggingIn([bool loggingIn = true, String errMsg]) {
    if (mounted) {
      setState(() {
//        _loggingIn = loggingIn;
//        _errorMessage = errMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Continue with google'),
            ),
            if (errorMessage != null) Text(errorMessage, style: TextStyle(color: Colors.red),)
          ],
        ),
      ),
    );
  }
}
