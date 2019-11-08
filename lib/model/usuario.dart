

class Usuario {
  String nome;
  int npiramides;
  String usuarioId;
  bool publicidade;
  //esse usuario pode relatar nessa piramides
  List<String> piramidesPodeRelatarId;
  List<String> piramidesAdmnistra;

  //List<Pergunta> perguntaDaUsuario;
  // Key key;

  // Usuario({this.nome, this.perguntaDaUsuario});
  Usuario(
      {this.nome,
      this.npiramides,
      this.piramidesPodeRelatarId,
      this.piramidesAdmnistra,
      this.publicidade});

  Map toMap() {
// print(piramidesPodeRelatarId.toString());
// print(piramidesPodeRelatarId.toList());
    if (piramidesPodeRelatarId == null) {
      piramidesPodeRelatarId = [];
    }
    if (piramidesAdmnistra == null) {
      piramidesAdmnistra = [];
    }
    var array = piramidesPodeRelatarId.map((t) => t).toList();
    var array1 = piramidesAdmnistra.map((t) => t).toList();

    Map<String, dynamic> map = {
      'nome': nome,
      'npiramides': npiramides,
      'piramidesPodeRelatarId': array,
      'piramidesAdmnistra': array1,
      'publicidade': publicidade,
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
    publicidade = map['publicidade'];
    usuarioId = usuarioPassadoId;

    if (piramidesPodeRelatarId == null) {
      piramidesPodeRelatarId = [];
    }
    if (piramidesAdmnistra == null) {
      piramidesAdmnistra = [];
    }

    for (var item in map['piramidesPodeRelatarId']) {
      piramidesPodeRelatarId.add(item);
    }

    for (var item1 in map['piramidesAdmnistra']) {
      piramidesAdmnistra.add(item1);
    }
  }
}
