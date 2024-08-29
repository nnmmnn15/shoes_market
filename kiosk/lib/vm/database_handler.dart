import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'abcd.db'),
      onCreate: (db, version) async {
        await db.execute("""
            create table shop
            (
              id integer primary key autoincrement,
              name text,
              location text,
              phone text
            )
        """);
        await db.execute("""
            create table product
            (
              id text,
              size integer,
              name text,
              color text,
              price integer,
              image blob,
              brand text,
              primary key(id, size)
            )
        """);
        await db.execute("""
            create table transport
            (
              id integer,
              status text,
              shop_id integer,
              product_id text,
              date text,
              primary key(id, status)
            )
        """);
        await db.execute("""
            create table customer
            (
              seq integer primary key autoincrement,
              id text,
              name text,
              phone text,
              password text
            )
        """);
        await db.execute("""
            create table purchase
            (
              id text,
              status text,
              shop_id integer,
              customer_seq integer,
              product_id text,
              product_size integer,
              purchasedate text,
              purchaseprice integer,
              quantity integer,
              primary key(id, status)
            )
        """);
      },
      version: 1,
    );
  }

  Future<List<dynamic>> checkCustomer(String id, String pw) async {
    final Database db = await initializeDB();
    int idCheck = 0;
    dynamic idSeq = 0;
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select seq, count(id) as id from customer where id = ? and password = ?',
        [id, pw]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        idCheck = res['id'];
        idSeq = res['seq'];
      },
    ).toList();
    return [idCheck, idSeq];
  }

  Future<int> checkRecive(int seq, String recive) async {
    int receiveCheck = 0; // 여부 확인
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select count(id) as checkreceive from purchase where customer_seq = ? and id = ?',
        [seq, recive]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        receiveCheck = res['checkreceive'];
      },
    ).toList();
    return receiveCheck;
  }
}
