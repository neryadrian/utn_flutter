import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utn_flutter/models/simple_ticker_model.dart';

class SymbolAdd extends StatefulWidget {
  const SymbolAdd({super.key});

  @override
  State<StatefulWidget> createState() => _SymbolAddState();
}

class _SymbolAddState extends State<SymbolAdd> {
  final CollectionReference<Map<String, dynamic>> _symbolsCollection =
      FirebaseFirestore.instance.collection('symbols');

  List<String> _symbols = [];

  final int _maxLength = 10;

  Future<List<SimpleTicker>> getPrices() async {
    final response = await http
        .get(Uri.parse('https://api.binance.com/api/v3/ticker/price'));

    if (response.statusCode < 300) {
      final List decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded.map((d) => SimpleTicker.fromJson(d)).toList();
      }
    }
    return [];
  }

  @override
  initState() {
    getPrices().then((prices) {
      print('Prices: ' + prices.toString());
      setState(() {
        _symbols = prices.map((p) {
          return p.symbol;
        }).toList();
        print('Symbols: ' + _symbols.toString());
      });
    }).catchError((error) {
      print('Error: ' + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          onSubmitted: (String submitted) {
            print('Submitted: ' + submitted);
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        List<String> filteredSymbols = _symbols.where((String s) {
          return s.toLowerCase().contains(controller.text);
        }).toList();

        int lengthDifference = filteredSymbols.length;

        filteredSymbols = filteredSymbols.sublist(
            0,
            filteredSymbols.length > _maxLength
                ? _maxLength
                : filteredSymbols.length);

        lengthDifference = lengthDifference - filteredSymbols.length;

        return [
          ...filteredSymbols.map((String symbol) {
            return ListTile(
              title: Text(symbol),
              onTap: () {
                print('Selected symbol: ' + symbol);
                _symbolsCollection
                    .add({'name': symbol})
                    .then((value) => print("Symbol added"))
                    .catchError(
                        (error) => print("Failed to add symbol: $error"));
                controller.closeView(symbol);
              },
            );
          }),
          ...[
            if(lengthDifference > 0) ListTile(
              title: Text('...$lengthDifference more elements'),
            )
          ]
        ];
      },
    );
  }
}
