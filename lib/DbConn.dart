import 'package:mongo_dart/mongo_dart.dart';

class DbConn {
  final String _url;
  late Db _db;

  DbConn(this._url);

  Future<Db> connect() async {
    try {
      _db = await Db.create(_url);
      await _db.open();
      print("conectou se ao BD ✔");
    } on MongoDartError catch (e) {
      print("Erro na conexão : $e ");
    }
    return _db;
  }

  Future<void> close() async {
    await _db.close();
    print("Conexão FECHADA🔒");
  }
}
