import 'package:comportamentocoletivo/model/camada.dart';

class Piramide {
  String nome;
  bool publica;
  String dataInicio;
  List<DateTime> datasZerar;
  List<Camada> camadasDaPiramide;
  String piramideId;
//  String informacoesId;
  String usuarioId;

  Piramide(
      {this.nome,
      this.publica,
      this.dataInicio,
      this.datasZerar,
      this.camadasDaPiramide,
      //piramideId
    ///  this.informacoesId,
      this.piramideId,
      this.usuarioId});

  Map toMap({String uid}) {
    Map<String, dynamic> map = {
      'nome': nome,
      'publica': publica,
      'dataInicio': dataInicio,
    //  'informacoesId': informacoesId,
      'ncamadas': camadasDaPiramide.length,
      //'usuarioId': usuarioId,
    };
    if (uid != null) {
      map['usuarioId'] = uid;
    }
    // if (id != null) {
    //   map['idColumn'] = id;
    // }

    for (var i = 0; i < camadasDaPiramide.length; i++) {
      Map<String, dynamic> camada = {
        'nome': camadasDaPiramide[i].nome,
        // 'total':camadasDaPiramide[i].total
      };
      if (camadasDaPiramide[i].total == null) {
        camada['total'] = 0;
      } else {
        camada['total'] = camadasDaPiramide[i].total;
      }
      map.addAll({'camada$i': camada});
    }

    return map;
  }

  Piramide.fromMap(Map map, String documentIdPasado) {
    //  id = map['idColumn'];
    nome = map['nome'];
    publica = map['public'];
    dataInicio = map['dataInicio'];
    piramideId = documentIdPasado;
    usuarioId = map['usuarioId'];
 //   informacoesId=map['informacoesId'];

    if (camadasDaPiramide == null) {
      camadasDaPiramide = [];
    }

    for (var i = 0; i < map['ncamadas']; i++) {
      Camada c = Camada(
        nome: map['camada$i']['nome'],
        total: map['camada$i']['total'],
      );
      camadasDaPiramide.add(c);
    }
  }

  // @override
  // String toString() {
  //   return "Lista(id: $id, amanho, ordem $ordem,data $data)";
  // }

}
