import 'dart:ffi';

class SimpleTicker {
  final String symbol;
  final double price;

  const SimpleTicker({
    required this.symbol,
    required this.price
  });

  factory SimpleTicker.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'symbol': String symbol,
        'price': String price
      } => 
      SimpleTicker(symbol: symbol, price: double.parse(price)),
      _ => throw const FormatException('Failed to load ticker.'),
    };
  }
}