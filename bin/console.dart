import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'Operacoes.dart';

void limparTela() {
  print('\x1B[2J\x1B[0;0H');
}

void main() async {
  String? search;
  String? nome;
  double? long;
  double? lat;

  print(
    "BEM VINDO AO ADMINISTRADOR DE SCE!! (Sistema de cadastro de estabelecimentos)\n\n Insira: \n 1 - Pesquisar Estabelecimentos \n 2 - Inserir um estabelecimento \n 3 - Editar um estabelecimento \n 4 - Apagar um estabelecimento",
  );

  int op = int.parse(stdin.readLineSync()!);

  switch (op) {
    case 1:
      limparTela();

      print("Escreva o nome do estabelecimento");
      nome = stdin.readLineSync();
      print("Escreva a latitude do estabelecimento");
      lat = double.tryParse(stdin.readLineSync()!);
      print("Escreva a longitude do estabelecimento");
      long = double.tryParse(stdin.readLineSync()!);

      if (nome == null || lat == null || long == null) {
        print("");
      } else {
        Operacoes.adicionarEstabelecimento();
      }

      break;
    default:
  }

  // Função para limpar a tela

  void limparTela() {
    stdout.write('\x1B[2J\x1B[0;0H');
  }
}
