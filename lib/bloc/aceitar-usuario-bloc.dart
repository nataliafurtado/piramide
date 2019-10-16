import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/pedido.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AceitarUsuarioBloc extends BlocBase {
  AceitarUsuarioBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  //final  Pedido p = Pedido(nome: 'hhhh');

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final piramideController =
  //     BehaviorSubject<Pedido>.seeded(Pedido(camadasDaPedido: []));
  // Observable<Pedido> get piramideFluxo => piramideController.stream;
  // Sink<Pedido> get piramideEvent => piramideController.sink;

  // final camadaSelecinadaController = BehaviorSubject<int>.seeded(0);
  // Observable<int> get camadaSelecinadaFluxo =>
  //     camadaSelecinadaController.stream;
  // Sink<int> get camadaSelecinadaEvent => camadaSelecinadaController.sink;

  static List<Pedido> listPiram = [Pedido(nome: 'ddd')];

  var pedidosController = BehaviorSubject<List<Pedido>>.seeded(listPiram);
  Observable<List<Pedido>> get pedidosFluxo => pedidosController.stream;
  Sink<List<Pedido>> get pedidosEvent => pedidosController.sink;

  void recusarUsuario(int pedidoIndex) async {
   // print('ac eitar usuario');
    //mudar status do pedido e colocar no usuario na lista uma piramide q agora ele pode relatar
    Pedido pedido = pedidosController.value[pedidoIndex];
    pedido.situacaoPedido = pedidosEnum.negado;
    await db
        .collection('pedidos')
        .document(pedido.pedidoId)
        .updateData(pedido.toMap());

  //  print(pedido.usuarioId + '2222222');
    DocumentSnapshot result =
        await db.collection('usuarios').document(pedido.usuarioId).get();

    // print(result.data.toString());
    Usuario user1 = Usuario.fromMap(result.data,result.documentID);
//print(result.data['piramidesPodeRelatarId'].toString());
// print(user1.piramidesPodeRelatarId.toString()+'length');
       user1.piramidesPodeRelatarId.add(pedido.piramideId);

    await db
        .collection('usuarios')
        .document(pedido.usuarioId)
        .updateData(user1.toMap());
  }


    void aceitarUsuario(int pedidoIndex) async {
    print('ac eitar usuario');
    //mudar status do pedido e colocar no usuario na lista uma piramide q agora ele pode relatar
    Pedido pedido = pedidosController.value[pedidoIndex];
    pedido.situacaoPedido = pedidosEnum.aceito;
    await db
        .collection('pedidos')
        .document(pedido.pedidoId)
        .updateData(pedido.toMap());

  //  print(pedido.usuarioId + '2222222');
    DocumentSnapshot result =
        await db.collection('usuarios').document(pedido.usuarioId).get();

    // print(result.data.toString());
    Usuario user1 = Usuario.fromMap(result.data,result.documentID);
//print(result.data['piramidesPodeRelatarId'].toString());
// print(user1.piramidesPodeRelatarId.toString()+'length');
       user1.piramidesPodeRelatarId.add(pedido.piramideId);

    await db
        .collection('usuarios')
        .document(pedido.usuarioId)
        .updateData(user1.toMap());
  }

  //  .where('piramideId', isEqualTo: piramideId)
  //  final FirebaseUser user = await _auth.currentUser();
  //final String uid = user.uid;
  /// db.collection('pedidos').where('',isEqualTo: autocomplete).getDocuments();

  void carregaUsuario(String usuarioId) {}
  void carregaPedidos(String piramideId) async {
    print(piramideId);
    print('enttraste');
    //  final FirebaseUser user = await _auth.currentUser();
    //final String uid = user.uid;
    /// db.collection('pedidos').where('',isEqualTo: autocomplete).getDocuments();
    final QuerySnapshot result = await db
        .collection('pedidos')
        .where('piramideId', isEqualTo: piramideId)
        // //.where('nome', isEqualTo: autocomplete)
        .where('situacaoPedido', isEqualTo: pedidosEnum.aberto.toString())
        .getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    //  print(documents.length.toString() + 'tamanho');

    List<Pedido> l = [];
    documents.forEach((data) {
      //  print(data.data['dataInicio'] + 'NNNOOOOMMMEEE');
      l.add(Pedido.fromMap(data.data, data.documentID));
    });
    listPiram = l;
    print(l.length.toString() + 'lenth');

    pedidosEvent.add(listPiram);
  }

  // Future<String> salvarNovaPedido() async {

  //   return null;
  // }

  @override
  void dispose() {
    pedidosController.close();

    super.dispose();
  }

}
