import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SymbolAdd extends StatefulWidget {
  const SymbolAdd({super.key});

  @override
  State<StatefulWidget> createState() => _SymbolAddState();
}

class _SymbolAddState extends State<SymbolAdd> {
  final CollectionReference<Map<String, dynamic>> _symbolsCollection =
      FirebaseFirestore.instance.collection('symbols');

  List<String> _symbols = [
    'btcusdt',
    'ethusdt',
    'bnbusdt',
    'xrpusdt',
    'dogeusdt',
    'shibusdt'
  ];

  final int _maxLength = 3;

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
        filteredSymbols = filteredSymbols.sublist(
            0,
            filteredSymbols.length > _maxLength
                ? _maxLength
                : filteredSymbols.length);
        return filteredSymbols.map((String symbol) {
          return ListTile(
            title: Text(symbol),
            onTap: () {
              print('Selected symbol: ' + symbol);
              _symbolsCollection
                  .add({'name': symbol})
                  .then((value) => print("Symbol Added"))
                  .catchError((error) => print("Failed to add symbol: $error"));
              controller.closeView(symbol);
            },
          );
        });
      },
    );
  }
}
