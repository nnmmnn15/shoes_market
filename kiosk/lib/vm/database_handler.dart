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
              color text,
              price int,
              size text,
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
              shop_id int,
              product_id int,
              date text,
              status text
            )
        """
        );
        await db.execute(
        """
            create table customer
            (
              seq integer primary key autoincrement,
              id text,
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
              status text,
              shop_id int,
              customer_seq int,
              product_id int,
              product_color text,
              purchasedate text,
              purchaseprice int,
              quantity int
            )
        """
        );
      },
      version: 1,
    );
  }


}