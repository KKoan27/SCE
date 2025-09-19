import 'package:mongo_dart/mongo_dart.dart';

import '../lib/DbConn.dart';

void main(List<String> arguments) async {
  print(
    "BEM VINDO AO ADMINISTRADOR DE SCE!! (Sistema de cadastro de estabelecimentos)\n\n Insira: \n 1 - Pesquisar Estabelecimentos \n 2 - Inserir um estabelecimento \n 3 - Editar um estabelecimento \n 4 - Apagar um estabelecimento",
  );

  var dbconn = DbConn(
    "mongodb+srv://DELCO:Senhaforte2711@cluster0.z3vmnhg.mongodb.net/",
  );

  try {
    Db db = await dbconn.connect();

    DbCollection estabelecimentos = db.collection('Estabelecimentos');

    var result = await estabelecimentos.find().toList();

    for (var i in result) {
      print(i);
    }
    dbconn.close();
  } on MongoDartError catch (e) {
    print("Erro no mongodart : $e");
  } catch (e) {
    print("erro : $e");
  }
}
