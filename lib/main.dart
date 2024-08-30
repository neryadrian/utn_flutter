import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:utn_flutter/components/auth_frame.dart';
import 'package:utn_flutter/components/symbols_list.dart';

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
            const AuthFrame(),
            const Text('List'),
            const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Symbol'),
            ),
            TextButton(
              onPressed: () {
                print('Add symbol pressed');
              },
              child: const Text('Add symbol'),
            ),
            const SymbolsList(),
          ],
        ),
      ),
    );
  }
}
