import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SymbolAdd extends StatefulWidget {
  const SymbolAdd({super.key});

  @override
  State<StatefulWidget> createState() => _SymbolAddState();
}

class _SymbolAddState extends State<SymbolAdd> {
  final Stream<QuerySnapshot> _symbolsStream =
      FirebaseFirestore.instance.collection('symbols').snapshots();

  List<String> _symbols = ['btcusdt', 'ethusdt', 'bnbusdt'];
  List<String> _filteredSymbols = [];

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
        return filteredSymbols.map((String symbol) {
          return ListTile(
            title: Text(symbol),
            onTap: () {
              print('Selected symbol: ' + symbol);
              controller.closeView(symbol);
            },
          );
        });
      },
    );
  }
}
