import 'package:comportamentocoletivo/model/enums.dart';

class Pergunta {
  String perguntaTitulo;
  bool obrigatoria;
  perguntasEnum perguntaEnum;
  String dataCriacao;
  String perguntaId;

  Pergunta(
      {this.perguntaTitulo,
      this.obrigatoria = false,
      this.perguntaEnum,
      this.dataCriacao,
      this.perguntaId});

  Map toMap(int ncamada) {
    Map<String, dynamic> map = {
      'perguntaTitulo': perguntaTitulo,
      'obrigatoria': obrigatoria,
      'perguntaEnum': perguntaEnum.toString(),
      'dataCriacao': dataCriacao,
      'ncamada': ncamada.toString(),
    };

    return map;
  }

  Pergunta.fromMap(Map map, String perguntaIdPassado) {
    //  id = map['idColumn'];
    perguntaTitulo = map['perguntaTitulo'];
    obrigatoria = map['obrigatoria'];
    perguntaEnum = PerguntasEnumConverter().enumConverter(map['perguntaEnum']);
    dataCriacao = map['dataCriacao'];
    perguntaId = perguntaIdPassado;
  }
}
