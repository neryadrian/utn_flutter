import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO for development purposes
  print('Starting emulators');
  /*if (kDebugMode) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      print(e);
    }
  }*/
  print('Finishing emulators start');

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    print('AuthListener user' + user.toString());
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextButton(
              onPressed: () => {signInWithGoogle()},
              child: const Text('SignIn'),
            ),
            TextButton(
              onPressed: () => {signOutWithGoogle()},
              child: const Text('SingOut'),
            ),
            const Text('Hello World'),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
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
  print('SignInResult:' + signInResult.toString());
  return signInResult;
}

Future<void> signOutWithGoogle() async {
  FirebaseAuth.instance.signOut();
}
