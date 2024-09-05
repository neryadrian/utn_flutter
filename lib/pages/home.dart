import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utn_flutter/components/symbol_add.dart';
import 'package:utn_flutter/components/symbols_list.dart';
import 'package:utn_flutter/models/simple_ticker_model.dart';

class _SymbolDocument {
  String id;
  String name;

  _SymbolDocument({required this.id, required this.name});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final CollectionReference<Map<String, dynamic>> _symbolsCollection =
      FirebaseFirestore.instance.collection('symbols');

  User? _user;
  List<_SymbolDocument> _symbols = [];
  List<SimpleTicker> _prices = [];
  bool hasError = false;
  bool waiting = true;

  StreamSubscription? _userSubscription;
  StreamSubscription? _dataSubscription;

  @override
  initState() {
    // Auth listener
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });

    // Firestore listener
    _dataSubscription = _symbolsCollection.snapshots().listen((QuerySnapshot snapshot) {
      List<_SymbolDocument> newSymbols = [];
      for (final DocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String? name = data['name'];
        final String id = document.id;
        if (name != null) newSymbols.add(_SymbolDocument(id: id, name: name));
      }

      _setSymbols(newSymbols);
    });

    super.initState();
  }

  @override
  void dispose() {
    if(_userSubscription != null) _userSubscription!.cancel();
    if(_dataSubscription != null) _dataSubscription!.cancel();
    super.dispose();
  }

  void _setSymbols(List<_SymbolDocument> symbols) async {
    _symbols = symbols;
    print('Home Symbols: ' + symbols.length.toString());
    List<SimpleTicker> newPrices = await _getPrices();
    print('Home Prices: ' + newPrices.length.toString());
    setState(() {
      _prices = newPrices.where((SimpleTicker price) {
        return _symbols.map((s) {
          return s.name.toLowerCase();
        }).contains(price.symbol.toLowerCase());
      }).toList();
    });
  }

  void _deleteSymbol(String name) {
    for (final document in _symbols) {
      if (document.name.toLowerCase() == name.toLowerCase()) {
        _symbolsCollection
            .doc(document.id)
            .delete();
      }
    }
  }

  Future<void> _signOutWithGoogle(BuildContext buildContext) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(buildContext);
  }

  Future<List<SimpleTicker>> _getPrices() async {
    final response = await http
        .get(Uri.parse('https://api.binance.com/api/v3/ticker/price'));

    if (response.statusCode < 300) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((d) => SimpleTicker.fromJson(d)).toList();
    }
    return [];
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
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            _setSymbols(_symbols);
          },
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              SymbolsList(
                prices: _prices,
                onPressed: _deleteSymbol,
              ),
              const SymbolAdd(),
            ],
          ),
        ),
      ),
    );
  }
}
