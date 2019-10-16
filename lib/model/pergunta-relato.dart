import 'package:comportamentocoletivo/model/enums.dart';

class PerguntaRelato {
  String perguntaId;
  String resposta;
  perguntasEnum perguntaEnum;
  String perguntaTitulo;
  bool obrigatoria;

  PerguntaRelato(
      {this.resposta,
      this.perguntaId,
      this.perguntaEnum,
      this.perguntaTitulo,
      this.obrigatoria});

  Map toMap() {
    Map<String, dynamic> map = {
      'resposta': resposta,
      'perguntaId': perguntaId,
      'perguntaEnum': perguntaEnum.toString(),
      'perguntaTitulo': perguntaTitulo,
      'obrigatoria': obrigatoria,
    };

    return map;
  }

  PerguntaRelato.fromMap(Map map) {
    resposta = map['resposta'];
    perguntaId = map['perguntaId'];
    perguntaEnum = map['perguntaEnum'];
    perguntaTitulo = map['perguntaTitulo'];
    obrigatoria = map['obrigatoria'];
  }

   PerguntaRelato.fromMapDePergunta(Map map, String perguntaIdPassada) {
    perguntaTitulo = map['perguntaTitulo'];
    obrigatoria = map['obrigatoria'];
    perguntaEnum = PerguntasEnumConverter().enumConverter(map['perguntaEnum']);
    perguntaId = perguntaIdPassada;


  }
}
