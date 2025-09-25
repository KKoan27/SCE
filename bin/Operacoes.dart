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

  static Future<void> adicionarEstabelecimento(
    Estabelecimentos estabelecimento,
  ) async {
    Db db = await dbConn.connect();
    var collection = db.collection('Estabelecimentos');
    itemsEstabelecimento = await collection.find().toList();

    if (estabelecimento.validacao(itemsEstabelecimento) == true) {
      var lugarPerto = await collection.findOne({
        'location': {
          '\$near': {
            '\$geometry': estabelecimento.toGeoPoint(),
            '\$maxDistance': 2000,
          },
        },
      });

      if (lugarPerto != null) {
        print("Já existe um lugar próximo ${lugarPerto['nome']}");
        db.close();
        return;
      } else {
        WriteResult result = await collection.insertOne(
          estabelecimento.toMongoDoc(),
        );

        if (result.writeError == null) {
          print("estabelecimento adicionado !!! ");
        } else {
          print("Erro na inserção!");
        }

        db.close();

        return;
      }
    } else {
      return;
    }
  }

  static Future<List<Map<String, dynamic>>?> buscarEstabelecimentos({
    String? search,
  }) async {
    Db db = await dbConn.connect();
    DbCollection collection = db.collection("Estabelecimentos");

    try {
      List<Map<String, dynamic>> resultado;

      if (search != null && search.isNotEmpty) {
        resultado = await collection.find({
          'nome': {r'$regex': search, r'$options': 'i'},
        }).toList();
      } else {
        resultado = await collection.find().toList();
      }

      return resultado;
    } on MongoDartError catch (e) {
      print("Erro no MongoDart: ${e.message} \nCódigo: ${e.errorCode}");
      return null;
    } finally {
      await db.close();
    }
  }

  static Future<bool> editarEstabelecimento(
    Estabelecimentos estabelecimento,
    String nome,
  ) async {
    Db db = await dbConn.connect();
    var collection = db.collection("Estabelecimentos");

    try {
      // Verifica se já existe um estabelecimento próximo
      var lugarPerto = await collection.findOne({
        'location': {
          '\$near': {
            '\$geometry': estabelecimento.toGeoPoint(),
            '\$maxDistance': 2000,
          },
        },
      });

      if (lugarPerto != null) {
        print("Já existe um lugar próximo: ${lugarPerto['nome']}");
        return false;
      }

      // Busca o documento antigo
      var docOld = await collection.findOne(where.eq('nome', nome));
      if (docOld == null) {
        print("Nome $nome não encontrado!");
        return false;
      }

      // Atualiza apenas os campos do objeto
      await collection.updateOne(
        where.eq('nome', nome),
        ModifierBuilder()
            .set('nome', estabelecimento.Nome)
            .set('location', estabelecimento.toGeoPoint()),
      );

      print("Estabelecimento atualizado com sucesso!");
      return true;
    } on MongoDartError catch (e) {
      print("Erro do Mongo: ${e.message}");
      return false;
    } catch (e) {
      print("Erro geral: $e");
      return false;
    } finally {
      await db.close();
    }
  }

  static Future<void> deletarEstabelecimento(String nome) async {
    Db db = await dbConn.connect();
    DbCollection collection = db.collection("Estabelecimentos");

    try {
      var result = await collection.deleteOne({'nome': nome});

      if (result.writeError == null) {
        print("Estabelecimento deletado ${result.document}");
      } else {
        throw Exception("Valor não encontrado no banco de dados");
      }
    } on MongoDartError catch (E) {
      print("erro no Mongo : ${E.message}");
    } catch (e) {
      print("erro na inserção: $e");
    } finally {
      db.close();
    }
  }
}
