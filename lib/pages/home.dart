import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  User? _user;

  @override
  initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      print('Home user' + user.toString());
    });
    super.initState();
  }

  Future<void> _signOutWithGoogle(BuildContext buildContext) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(buildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () => {_signOutWithGoogle(context)},
            child: Row(
              children: [
                Text('${_user?.displayName ?? ''} '),
                const Icon(Icons.logout)
              ],
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home content'),
      ),
    );
  }
}
