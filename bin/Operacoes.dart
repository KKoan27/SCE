import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/estabelecimentos.dart';
import 'package:console/DbConn.dart';
import 'dart:math';

class Operacoes {
  static DbConn dbConn = DbConn(
    "mongodb+srv://DELCO:Senhaforte2711@cluster0.z3vmnhg.mongodb.net/SCE",
  );

  static List<Map<String, dynamic>> itemsEstabelecimento = [];

  // essa função vai servir para fazer o calculo entre a distancia de um estabelecimento e outro, o resultado é essa diferença
  // Função bem complexa
  static double haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Raio da Terra em km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // distância em km
  }

  static Future<void> adicionarEstabelecimento(
    Estabelecimentos estabelecimento,
  ) async {
    Db db = await dbConn.connect();
    var collection = db.collection('Estabelecimentos');
    itemsEstabelecimento = await collection.find().toList();

    for (var e in itemsEstabelecimento) {
      if (e.containsKey('lat') &&
          e.containsKey('long') &&
          e.containsKey('nome')) {
        double latExistente = e['lat'];
        double lonExistente = e['long'];

        double distancia = haversine(
          estabelecimento.Latitude!,
          estabelecimento.Longitude!,
          latExistente,
          lonExistente,
        );

        if (distancia <= 10) {
          print(
            "Não é possivel inserir um estabelecimento neste local pois esta perto demais de outro",
          );
          db.close();

          return;
        }
      } else {
        print("Documento sem lat/long/nome: $e");
      }
    }
    WriteResult result = await collection.insertOne({
      'nome': estabelecimento.Nome,
      'long': estabelecimento.Latitude,
      'lat': estabelecimento.Longitude,
    });

    if (result.writeError == null) {
      print("estabelecimento adicionado !!! ");
    } else {
      print("Erro na inserção!");
    }

    db.close();

    return;
  }

  static Future<List<Map<String, dynamic>>?> buscarEstabelecimentos({
    String? search,
  }) async {
    Db db = await dbConn.connect();
    DbCollection collection = db.collection("Estabelecimentos");

    try {
      if (search != null) {
        itemsEstabelecimento = await collection.find({
          'nome': {r'$regex': search, r'$options': 'i'},
        }).toList();
      } else {
        itemsEstabelecimento = await collection.find().toList();

        db.close();
      }
      return itemsEstabelecimento;
    } on MongoDartError catch (e) {
      print("erro no mongodart : ${e.message} \n codigo : ${e.errorCode}");
      await db.close();
      return null;
    }
  }

  static Future<bool> editarEstabelecimento(
    Estabelecimentos estabelecimento,
    String nome,
  ) async {
    Db db = await dbConn.connect();

    DbCollection collection = db.collection("Estabelecimentos");
    itemsEstabelecimento = await collection.find().toList();

    for (var e in itemsEstabelecimento) {
      if (e.containsKey('lat') &&
          e.containsKey('long') &&
          e.containsKey('nome')) {
        if (e['nome'] != nome) {
          double latExistente = e['lat'];
          double lonExistente = e['long'];

          double distancia = haversine(
            estabelecimento.Latitude!,
            estabelecimento.Longitude!,
            latExistente,
            lonExistente,
          );

          if (distancia <= 10) {
            print(
              "Não é possivel inserir um estabelecimento neste local pois esta perto demais de outro",
            );
            db.close();

            return false;
          }
        }
      } else {
        print("Documento sem lat/long/nome: $e");
      }
    }
    try {
      var docold = await collection.findOne(where.eq('nome', nome));

      if (docold != null) {
        await collection.update(
          {'nome': nome},
          {
            '\$set': {
              'nome': estabelecimento.Nome,
              'lat': estabelecimento.Latitude,
              'long': estabelecimento.Longitude,
            },
          },
        );
      } else {
        print("Nome $nome não encontrado!");
        throw Exception("Não tem o nome no banco de dados");
      }
    } on MongoDartError catch (e) {
      print("Valor não alterado, erro : ${e.message}");
      db.close();
      return false;
    } catch (e) {
      print("ERRO GERAL DENTRO DO EDIT : $e");
    }
    db.close();
    stdin.readLineSync();

    return true;
  }

  static Future<void> deletarEstabelecimento(String nome) async {
    Db db = await dbConn.connect();
    DbCollection collection = db.collection("Estabelecimentos");

    try {
      var result = await collection.deleteOne({'nome': nome});

      if (result.writeError == null) {
        print("Estabelecimento deletado!");
      } else {
        throw Exception("Valor não encontrado no banco de dados");
      }
    } on MongoDartError catch (E) {
      print("erro no Mongo : ${E.message}");
    } catch (e) {
      print("erro na inserção: $e");
    }
  }
}
