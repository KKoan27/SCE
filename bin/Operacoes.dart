import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/estabelecimentos.dart';
import 'package:console/DbConn.dart';

class Operacoes {
  static void adicionarEstabelecimento(
    String nome,
    double long,
    double lat,
  ) async {
    DbConn dbConn = DbConn(
      "mongodb+srv://DELCO:<Senhaforte2711>@cluster0.z3vmnhg.mongodb.net/",
    );

    Db db = await dbConn.connect();
    var collection = db.collection('estabelecimentos');
    WriteResult result = await collection.insertOne({'nome': nome, 'long': long});
  }
}
