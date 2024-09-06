import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utn_flutter/pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  bool _loading = false;

  Future<void> _signInWithGoogle(BuildContext buildContext) async {
    setState(() {
      _loading = true;
    });

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

    if (signInResult.user != null) {
      Navigator.push(
          buildContext, MaterialPageRoute(builder: (context) => const Home()));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const FractionallySizedBox(
              widthFactor: 0.6,
              child: Text(
                'Crypto Watchlist',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
            ),
            if (!_loading)
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () {
                  _signInWithGoogle(context);
                },
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
