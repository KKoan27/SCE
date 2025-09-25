import 'dart:io';

class Estabelecimentos {
  String? Nome;
  double? Latitude;
  double? Longitude;

  Estabelecimentos({this.Nome, this.Latitude, this.Longitude});

  Map<String, dynamic> toMongoDoc() {
    return {
      "nome": Nome,
      "location": {
        "type": "Point",
        "coordinates": [Longitude, Latitude], // ordem correta
      },
    };
  }

  /// Pega só a parte de localização (para consultas geoespaciais)
  Map<String, dynamic> toGeoPoint() {
    return {
      "type": "Point",
      "coordinates": [Longitude, Latitude],
    };
  }

  bool validacao(List<Map<String, dynamic>> itensE) {
    for (var e in itensE) {
      var hasNome = e.containsKey('nome');
      var hasLocation =
          e.containsKey('location') &&
          e['location'] is Map &&
          (e['location'] as Map).containsKey('coordinates');

      if (!hasNome || !hasLocation) {
        print("Documento inválido: faltando nome ou location");
        continue;
      }

      var coords = (e['location']['coordinates'] as List);
      var hasLatLong =
          coords.length == 2 &&
          coords[0] != null && // longitude
          coords[1] != null; // latitude

      if (!hasLatLong) {
        print("Documento inválido: location sem coordenadas corretas");
        return false;
      } else {}
    }
    return true;
  }
}
