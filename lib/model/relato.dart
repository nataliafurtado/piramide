import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/pergunta-relato.dart';

class Relato {
  String datacriacao;
  String piramideId;
  int numeroCamada;
  int qtdPerguntas;
  String usuarioRelatouId;
  List<PerguntaRelato> perguntasRelato;
  String usarioNome;
  String relatoId;
  bool anonimo;

  Relato(
      {this.datacriacao,
      this.perguntasRelato,
      this.piramideId,
      this.numeroCamada,
      this.qtdPerguntas,
      this.usuarioRelatouId,
      this.usarioNome,
      this.relatoId,
      this.anonimo});

  Map toMap() {
    Map<String, dynamic> map = {
      'datacriacao': datacriacao,
      'piramideId': piramideId,
      'numeroCamada': numeroCamada,
      'usuarioRelatouId': usuarioRelatouId,
      'qtdPerguntas': qtdPerguntas,
      'usarioNome': usarioNome,
      'anonimo': anonimo,
    };
    if (perguntasRelato == null) {
      perguntasRelato = [];
    }
    if (perguntasRelato.isNotEmpty) {
      for (var i = 0; i < perguntasRelato.length; i++) {
        Map<String, dynamic> perguntaRelato = {
          'perguntaId': perguntasRelato[i].perguntaId,
          'resposta': perguntasRelato[i].resposta,
          'perguntaEnum': perguntasRelato[i].perguntaEnum.toString(),
          'perguntaTitulo': perguntasRelato[i].perguntaTitulo,
          'obrigatoria': perguntasRelato[i].obrigatoria,
        };
        map.addAll({'perguntaRelato$i': perguntaRelato});
      }
    }
    return map;
  }

  Relato.fromMap(Map map, String relatoPassadoId) {
    datacriacao = map['datacriacao'];
    piramideId = map['piramideId'];
    numeroCamada = map['numeroCamada'];
    usuarioRelatouId = map['usuarioRelatouId'];
    usarioNome = map['usarioNome'];
    anonimo = map['anonimo'];
    qtdPerguntas = map['qtdPerguntas'];

    relatoId = relatoPassadoId;
    if (perguntasRelato == null) {
      perguntasRelato = [];
    }
    print('fffffffffffffffffffffffffffffffff');
    print(relatoPassadoId);
    print(map['qtdPerguntas']);
    for (var i = 0; i < map['qtdPerguntas']; i++) {
      PerguntaRelato c = PerguntaRelato(
        perguntaId: map['perguntaRelato$i']['perguntaId'],
        resposta: map['perguntaRelato$i']['resposta'],
        perguntaEnum: PerguntasEnumConverter()
            .enumConverter(map['perguntaRelato$i']['perguntaEnum']),
        perguntaTitulo: map['perguntaRelato$i']['perguntaTitulo'],
        obrigatoria: map['perguntaRelato$i']['obrigatoria'],
      );
      perguntasRelato.add(c);
    }
  }
}
