import 'package:path/path.dart';
import 'package:shoes_market_app/model/customer.dart';
import 'package:shoes_market_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class CustomerHandler {
  DatabaseHandler handler = DatabaseHandler();

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
              purchaseid text,
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

  Future<List<Customer>> queryCustomer() async {
    int query = 1;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        select * from customer where seq = '${query}'
      """);
    return queryResult
        .map(
          (e) => Customer.fromMap(e),
        )
        .toList();
  }
}
