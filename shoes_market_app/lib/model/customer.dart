class Customer{
  int? seq;
  String id;
  String name;
  String phone;
  String password;

  Customer(
    {
      this.seq,
      required this.id,
      required this.name,
      required this.phone,
      required this.password,
    }
  );
  Customer.fromMap(Map<String, dynamic> res):
    seq = res['seq'],
    id = res['id'],
    name = res['name'],
    phone = res['phone'],
    password = res['password'];
}