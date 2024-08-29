import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler{
  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'abcd.db'),
      onCreate: (db, version) async{
        await db.execute(
        """
            create table shop
            (
              id integer primary key autoincrement,
              name text,
              location text,
              phone text
            )
        """
        );
        await db.execute(
        """
            create table product
            (
              id integer primary key autoincrement,
              size integer primary key,
              name text,
              color text,
              price integer,
              image blob,
              brand text
            )
        """
        );
        await db.execute(
        """
            create table transport
            (
              id integer primary key autoincrement,
              status primary key text
              shop_id integer,
              product_id integer,
              date text,
            )
        """
        );
        await db.execute(
        """
            create table customer
            (
              seq integer primary key autoincrement,
              id text primary key,
              name text,
              phone text,
              password text
            )
        """
        );
        await db.execute(
        """
            create table purchase
            (
              id integer primary key autoincrement,
              status text primary key,
              shop_id integer,
              customer_seq integer,
              product_id integer,
              product_size integer,
              purchasedate text,
              purchaseprice integer,
              quantity integer
            )
        """
        );
      },
      version: 1,
    );
  }


}