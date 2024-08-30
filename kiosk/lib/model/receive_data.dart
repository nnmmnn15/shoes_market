import 'dart:typed_data';

class ReceiveData {
  final String id;
  final String name;
  final int quantity;
  final int size;
  final String date;
  final Uint8List image;

  ReceiveData({
    required this.id,
    required this.name,
    required this.quantity,
    required this.size,
    required this.date,
    required this.image,
  });

  ReceiveData.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        quantity = res['quantity'],
        size = res['size'],
        date = res['purdate'],
        image = res['image'];
}
