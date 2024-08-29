import 'dart:ffi';

class Customer{
  final Int seq;
  final String id;
  final String name;
  final String phone;
  final String password;


  Customer({
  required this.seq,
  required this.id,
  required this.name,
  required this.phone,
  required this.password
  });


  Customer.fromMap(Map<String,dynamic>res)
  : seq = res['res'],
  id = res['id'],
  name = res['name'],
  phone = res['phone'],
  password =res['password'];
}

