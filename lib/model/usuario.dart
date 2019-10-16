import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:flutter/widgets.dart';

class Usuario {
  String nome;
  int npiramides;
  String usuarioId;
  //esse usuario pode relatar nessa piramides
  List<String> piramidesPodeRelatarId;

  //List<Pergunta> perguntaDaUsuario;
  // Key key;

  // Usuario({this.nome, this.perguntaDaUsuario});
  Usuario({this.nome, this.npiramides, this.piramidesPodeRelatarId});

  Map toMap() {
// print(piramidesPodeRelatarId.toString());
// print(piramidesPodeRelatarId.toList());
    if (piramidesPodeRelatarId == null) {
      piramidesPodeRelatarId = [];
    }
    var array = piramidesPodeRelatarId.map((t) => t).toList();

    Map<String, dynamic> map = {
      'nome': nome,
      'npiramides': npiramides,
      'piramidesPodeRelatarId': array,
      // 'publica': publica,
      // 'dataInicio': dataInicio,
    };
    // Map tt = piramidesPodeRelatarId.t
//      for (var i = 0; i < piramidesPodeRelatarId.length; i++) {

//      }
//  'piramidesPodeRelatarId':

    // if (id != null) {
    //   map['idColumn'] = id;
    // }
    //  if(marcada){

    //  }
    return map;
  }

  Usuario.fromMap(Map map, String usuarioPassadoId) {
    nome = map['nome'];
    npiramides = map['npiramides'];
    usuarioId = usuarioPassadoId;

    if (piramidesPodeRelatarId == null) {
      piramidesPodeRelatarId = [];
    }

    for (var item in map['piramidesPodeRelatarId']) {
      piramidesPodeRelatarId.add(item);
    }
  }
}
