import 'package:comportamentocoletivo/model/enums.dart';

class Pedido {
  String piramideId;
  // usuario que FEZ O PEDIDO
  String usuarioId;
  pedidosEnum situacaoPedido;
  String data;
  String nome;
  String pedidoId;

  //List<Pergunta> perguntaDaPedido;
  // Key key;

  // Pedido({this.nome, this.perguntaDaPedido});
  Pedido(
      {this.piramideId,
      this.usuarioId,
      this.situacaoPedido,
      this.data,
      this.nome,
      this.pedidoId});

  Map toMap() {
    Map<String, dynamic> map = {
      'piramideId': piramideId,
      'usuarioId': usuarioId,
      'situacaoPedido': situacaoPedido.toString(),
      'data': data,
      'nome': nome,
      //'pedidoId': pedidoId,
      // 'dataInicio': dataInicio,
    };
    // if (id != null) {
    //   map['idColumn'] = id;
    // }
    //  if(marcada){

    //  }
    return map;
  }

  Pedido.fromMap(Map map,String pedidoIdPassado) {
    piramideId = map['piramideId'];
    usuarioId = map['usuarioId'];
    nome = map['nome'];
    data = map['data'];
    pedidoId = pedidoIdPassado;

    situacaoPedido =
        PedidosEnumConverter().enumConverter(map['situacaoPedido']);
  }
}
