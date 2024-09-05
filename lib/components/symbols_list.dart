import 'package:flutter/material.dart';
import 'package:utn_flutter/models/simple_ticker_model.dart';

class SymbolsList extends StatelessWidget {
  final bool hasError;
  final bool waiting;
  List<SimpleTicker> prices;
  final void Function(String name)? onPressed;

  SymbolsList(
      {super.key,
      required this.prices,
      this.hasError = false,
      this.waiting = false,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return const Text('Something wrong');
    }

    if (waiting) {
      return const Text('Loading...');
    }

    return ListView(
      shrinkWrap: true,
      children: prices.map((SimpleTicker price) {
        return ListTile(
          title: Row(children: [
            Text(
              price.symbol.toUpperCase(),
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              price.price.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ]),
          trailing: IconButton(
            onPressed: () {
              if (onPressed != null) onPressed!(price.symbol);
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        );
      }).toList(),
    );
  }
}
