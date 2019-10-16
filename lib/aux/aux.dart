// import 'dart:async';


// import 'package:comportamentocoletivo/model/piramide.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// final String listaTable = "listasTable";

// final String idColumn = "idColumn";
// final String nameColumn = "nameColumn";

// final String itemsTable = "itemsTable";
// final String listasTableId = "listasTableId";
// final String idListaTable = "idListaTable";
// final String path = "path";

// class DBHelper {
//   static final DBHelper _instance = DBHelper.internal();

//   factory DBHelper() => _instance;

//   DBHelper.internal();

//   Database _db;

//   Future<Database> get db async {
//     if (_db != null) {
//       return _db;
//     } else {
//       _db = await initDb();
//       return _db;
//     }
//   }

//   Future<Database> initDb() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, "listas.db");
//    // print(path);

//     return await openDatabase(path, version: 1,
//         onCreate: (Database db, int newerVersion) async {
//       await db.execute(
//           "CREATE TABLE $listaTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT)");

//       await db.execute(
//           "CREATE TABLE $itemsTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"+
//            "$idListaTable INT,path TEXT,marcada BOOLEAN,ordem INT, data TEXT,gravacaoTamanho TEXT)");
//     });
//   }

//   Future<Lista> saveLista(Lista lista) async {
//     Database dbLista = await db;
//     lista.id = await dbLista.insert(listaTable, lista.toMap());
//     return lista;
//   }

//   Future<Piramide> saveItem(Piramide item) async {
//     Database dbLista = await db;
//     item.id = await dbLista.insert(itemsTable, item.toMap());
//     return item;
//   }

//   Future<Lista> getLista(int id) async {
//     Database dbLista = await db;
//     List<Map> maps = await dbLista.query(listaTable,
//         columns: [idColumn, nameColumn],
//         where: "$idColumn = ?",
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return Lista.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }



//   Future<Piramide> getItem(String caminho) async {
//     Database dbLista = await db;
//     List<Map> maps = await dbLista.query(itemsTable,
//         columns: [idColumn, nameColumn,idListaTable,'path','marcada','ordem','data','gravacaoTamanho'],
//         where: "path = ?",
//         whereArgs: [caminho]);
//     if (maps.length > 0) {
//       return Piramide.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }





//   Future<int> deleteLista(int id) async {
//     Database dbLista = await db;
//     return await dbLista
//         .delete(listaTable, where: "$idColumn = ?", whereArgs: [id]);
//   }


//   Future<int> deleteItem(int id) async {
//     Database dbLista = await db;
//     return await dbLista
//         .delete(itemsTable, where: "$idColumn = ?", whereArgs: [id]);
//   }

//   Future<int> updateLista(Lista lista) async {
//     Database dbLista = await db;
//     return await dbLista.update(listaTable, lista.toMap(),
//         where: "$idColumn = ?", whereArgs: [lista.id]);
//   }

//    Future<int> updateItem(Piramide item) async {
//     Database dbLista = await db;
//     return await dbLista.update(itemsTable, item.toMap(),
//         where: "$idColumn = ?", whereArgs: [item.id]);
//   }

//   Future<List> getAllListas() async {
//     Database dbLista = await db;
//     List listMap = await dbLista.rawQuery("SELECT * FROM $listaTable");
//     List<Lista> listLista = List();
//     for (Map m in listMap) {
//       listLista.add(Lista.fromMap(m));
//     }
//     return listLista;
//   }

// Future<int> getCountItemsDeLista(Lista lista)async{
//     Database dbLista = await db;
//     var qtd = await dbLista.rawQuery('SELECT count($idColumn) from $itemsTable where $idListaTable=${lista.id}');
//     return Sqflite.firstIntValue(qtd);
  
// }


//   Future<List> getItems(Lista lista) async {    
//     Database dbLista = await db;    
//     List listMap = await dbLista.rawQuery("SELECT * FROM $itemsTable where $idListaTable=${lista.id}");    
//     List<Item> listItems = List();
//     for (Map m in listMap) {
//       listItems.add(Item.fromMap(m));
//     }
//    // print(listItems.toString());
//     return listItems;
//   }

//   Future<int> getNumber() async {
//     Database dbLista = await db;
//     return Sqflite.firstIntValue(
//         await dbLista.rawQuery("SELECT COUNT(*) FROM $listaTable"));
//   }

//   Future close() async {
//     Database dbLista = await db;
//     dbLista.close();
//   }
// }

// class Lista {
//   int id;
//   String name;

//   Lista();

//   Lista.fromMap(Map map) {
//     id = map[idColumn];
//     name = map[nameColumn];
//   }

 

//   Map toMap() {
//     Map<String, dynamic> map = {
//       nameColumn: name,
//     };
//     if (id != null) {
//       map[idColumn] = id;
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return "Lista(id: $id, name: $name)";
//   }
// }