

class Credito {
  String usuarioId;
  String data;
  String idLoja;
  String sku;
  String creditoId;
  double valor;


  // List<PerguntaCredito> perguntasCredito;

  Credito(
      {this.data, this.idLoja, this.valor, this.usuarioId,this.sku});

  Map toMap() {
    Map<String, dynamic> map = {
      'data': data,
      'idLoja': idLoja,
      'valor': valor,
      'sku': sku,
    
      'usuarioId': usuarioId,
    };

    return map;
  }

  Credito.fromMap(Map map, String creditoPassadoId) {
    data = map['data'];
    idLoja = map['idLoja'];
    valor = map['valor'];
    sku = map['sku'];

    usuarioId = map['usuarioId'];


  }
}
