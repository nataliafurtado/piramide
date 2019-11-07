

class Debito {
  String usuarioId;
  String data;
  String piramideId;
  String relatoId;
  String debitoId;
  double valor;

  // List<PerguntaDebito> perguntasDebito;

  Debito(
      {this.data, this.piramideId, this.valor, this.relatoId, this.usuarioId,this.debitoId});

  Map toMap() {
    Map<String, dynamic> map = {
      'data': data,
      'piramideId': piramideId,
      'valor': valor,  
      'relatoId': relatoId,
      'usuarioId': usuarioId,
    };

    return map;
  }

  Debito.fromMap(Map map, String debitoPassadoId) {
    data = map['data'];
    piramideId = map['piramideId'];
    valor = map['valor'];
    debitoId = debitoPassadoId;
    relatoId = map['relatoId'];
    usuarioId = map['usuarioId'];


  }
}
