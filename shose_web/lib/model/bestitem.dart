import 'dart:typed_data';

class Bestitem{
  final String name;
  final String color;
  final int price;
  final Uint8List image;

  Bestitem(
    {
      required this.name,
      required this.color,
      required this.price,
      required this.image
    }
  );

  Bestitem.fromMap(Map<String, dynamic> res)
  : name = res['name'],
    color = res['color'],
    price = res['price'],
    image = res['image'];
}