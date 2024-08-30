import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SymbolsList extends StatefulWidget {
  const SymbolsList({super.key});

  @override
  State<StatefulWidget> createState() => _SymbolsListState();
}

class _SymbolsListState extends State<SymbolsList> {
  final Stream<QuerySnapshot> _symbolsStream =
      FirebaseFirestore.instance.collection('symbols').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _symbolsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
              );
            }).toList(),
          );
        });
  }
}
