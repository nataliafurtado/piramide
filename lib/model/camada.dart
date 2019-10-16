import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:flutter/widgets.dart';

class Camada {
  String nome;
  int total;
  double porcentagem;
  List<Pergunta> perguntaDaCamada;
  // Key key;

  // Camada({this.nome, this.perguntaDaCamada});
  Camada({Key key, this.nome, this.perguntaDaCamada,this.total,this.porcentagem});

  Map toMap() {
    Map<String, dynamic> map = {
      'nome': nome,
      'total': total,
      // 'publica': publica,
      // 'dataInicio': dataInicio,
    };
    // if (id != null) {
    //   map['idColumn'] = id;
    // }
    //  if(marcada){

    //  }
    return map;
  }

  Camada.fromMap(Map map) {
    nome = map['nome'];
    total = map['total'];
  }
}
