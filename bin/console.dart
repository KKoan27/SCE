import '../lib/estabelecimentos.dart';
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
  while (true) {
    print(
      "BEM VINDO AO ADMINISTRADOR DE SCE!! (Sistema de cadastro de estabelecimentos)\n\n Insira: \n 1 - Pesquisar Estabelecimentos \n 2 - Inserir um estabelecimento \n 3 - Editar um estabelecimento \n 4 - Apagar um estabelecimento \n 0 - Para sair do programa",
    );

    try {
      int op = int.parse(stdin.readLineSync()!);
      switch (op) {
        case 0:
          limparTela();
          print("Saindo do aplicativo");
          exit(0);

        case 1:
          limparTela();
          print(
            "Gostaria de pesquisar algo em especifico?(caso não, apenas aperte enter)",
          );

          search = stdin.readLineSync();

          List<Map<String, dynamic>>? result =
              await Operacoes.buscarEstabelecimentos(search: search);

          if (result != null) {
            limparTela();
            print("ESTABELECIMENTOS BUSCADOS\n\n");

            for (var i in result) {
              print("NOME : ${i['nome']}");
              print("LATITUDE : ${i['lat']}");
              print("LONGITUDE : ${i['long']}");
              print("------------------------- \n");
            }
          } else {
            return;
          }
          stdin.readLineSync();

          break;

        case 2:
          limparTela();

          print("Escreva o nome do estabelecimento");
          nome = stdin.readLineSync();
          print("Escreva a latitude do estabelecimento");
          lat = double.tryParse(stdin.readLineSync()!);
          print("Escreva a longitude do estabelecimento");
          long = double.tryParse(stdin.readLineSync()!);

          print("DEBUG: nome=[$nome] , lat=[$lat], long=[$long]");

          if (nome == null || lat == null || long == null) {
            print("Ta nulo aqui");
          } else {
            Estabelecimentos estabelecimento = Estabelecimentos(
              Nome: nome,
              Latitude: lat,
              Longitude: long,
            );

            await Operacoes.adicionarEstabelecimento(estabelecimento);
          }

          break;

        case 3:
          limparTela();
          print("Digite o nome do estabelecimento que voce quer alterar");
          String nomeold = stdin.readLineSync()!;

          print("Insira o nome para o $nomeold");
          nome = stdin.readLineSync();

          print("Insira a latitude nova para o $nomeold");
          lat = double.tryParse(stdin.readLineSync()!);

          print("Insira a longitude nova para o $nomeold");
          long = double.tryParse(stdin.readLineSync()!);

          Estabelecimentos estabelecimento = Estabelecimentos(
            Nome: nome,
            Latitude: lat,
            Longitude: long,
          );

          bool result = await Operacoes.editarEstabelecimento(
            estabelecimento,
            nomeold,
          );

          if (result) {
            print("alterações efetivadas com sucesso");
          } else {
            print("alterações não feitas!");
          }

        case 4:
          limparTela();

          print("Digite o nome do estabelecimento que quer apagar");
          nome = stdin.readLineSync();

          await Operacoes.deletarEstabelecimento(nome!);

        default:
          limparTela();
          print("Inserção Invalida");
      }
    } on FormatException {
      limparTela();
      print("SEM TEXTO!!!! \n aperte enter para continuar");
    } catch (e) {
      limparTela();
      print("Exceção no MAIN $e \n Aperte enter para continuar");
    } finally {
      stdin.readLineSync();
      limparTela();
    }
    // Função para limpar a tela
  }
}
