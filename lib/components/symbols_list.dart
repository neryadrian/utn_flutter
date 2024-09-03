import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SymbolsList extends StatefulWidget {
  const SymbolsList({super.key});

  @override
  State<StatefulWidget> createState() => _SymbolsListState();
}

class _SymbolsListState extends State<SymbolsList> {
  final CollectionReference<Map<String, dynamic>> _symbolsCollection =
      FirebaseFirestore.instance.collection('symbols');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _symbolsCollection.snapshots(),
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
              final String name = data['name'] ?? '-';

              return ListTile(
                title: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    _symbolsCollection
                        .doc(document.id)
                        .delete()
                        .then((value) => print("Symbol deleted"))
                        .catchError((error) =>
                            print("Failed to delete symbol: $error"));
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              );
            }).toList(),
          );
        });
  }
}
