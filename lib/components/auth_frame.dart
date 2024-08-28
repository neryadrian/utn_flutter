import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFrame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthFrameState();
}

class _AuthFrameState extends State<AuthFrame> {
  User? _user;

  @override
  initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      print('AuthListener user' + user.toString());
    });
    super.initState();
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential signInResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return signInResult;
  }

  Future<void> _signOutWithGoogle() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (_user is User) {
      return (Row(
        children: [
          Text(_user?.displayName ?? ''),
          TextButton(
            onPressed: () => {_signOutWithGoogle()},
            child: const Text('SignOut'),
          ),
        ],
      ));
    } else {
      return (TextButton(
        onPressed: () => {_signInWithGoogle()},
        child: const Text('SignIn'),
      ));
    }
  }
}
