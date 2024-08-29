class Shop{
  int? id;
  String name;
  String location;
  String phone;

  Shop({
    this.id,
    required this.name,
    required this.location,
    required this.phone
  });

   Shop.fromMap(Map<String, dynamic> res):    
    id = res['id'],
    name = res['name'],
    location = res['location'],
    phone = res['phone'];
    
}