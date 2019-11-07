class Carteira {
  String usuarioId;
  String carteiraId;
  double saldo;
  //List<String> piramidePodeGastar;

  // List<PerguntaCarteira> perguntasCarteira;

  Carteira(
      {this.saldo,
      // this.piramidePodeGastar,
      this.usuarioId});

  Map toMap() {
    // if (piramidePodeGastar == null) {
    //   piramidePodeGastar = [];
    // }
    // var array = piramidePodeGastar.map((t) => t).toList();
    Map<String, dynamic> map = {
      'saldo': saldo,
      'usuarioId': usuarioId,
      // 'piramidePodeGastar': array,
    };

    return map;
  }

  Carteira.fromMap(Map map, String carteiraPassadoId) {
    saldo = map['saldo'].toDouble();
    usuarioId = map['usuarioId'];
    carteiraId = carteiraPassadoId;
    // if (piramidePodeGastar == null) {
    //   piramidePodeGastar = [];
    // }

    // for (var item in map['piramidePodeGastar']) {
    //   piramidePodeGastar.add(item);
    // }
  }
}
