import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/camada.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/pedido.dart';

import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ProcurarPiramideBloc extends BlocBase {
  ProcurarPiramideBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  //final  Piramide p = Piramide(nome: 'hhhh');

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final piramideController =
  //     BehaviorSubject<Piramide>.seeded(Piramide(camadasDaPiramide: []));
  // Observable<Piramide> get piramideFluxo => piramideController.stream;
  // Sink<Piramide> get piramideEvent => piramideController.sink;

  // final camadaSelecinadaController = BehaviorSubject<int>.seeded(0);
  // Observable<int> get camadaSelecinadaFluxo =>
  //     camadaSelecinadaController.stream;
  // Sink<int> get camadaSelecinadaEvent => camadaSelecinadaController.sink;

  static List<Piramide> listPiram = [];

  var piramidesController = BehaviorSubject<List<Piramide>>.seeded(listPiram);
  Observable<List<Piramide>> get piramidesFluxo => piramidesController.stream;
  Sink<List<Piramide>> get piramidesEvent => piramidesController.sink;

  void carregaPiramides(String autocomplete) async {
    //  final FirebaseUser user = await _auth.currentUser();
    //final String uid = user.uid;
    /// db.collection('piramides').where('',isEqualTo: autocomplete).getDocuments();
    final QuerySnapshot result = await db
        .collection('piramides')
        .where('nome', isGreaterThan: autocomplete)
        //.where('nome', isEqualTo: autocomplete)
        .where('nome', isLessThan: autocomplete + 'z')
        .getDocuments();
    List<DocumentSnapshot> documents = result.documents;
    //  print(documents.length.toString() + 'tamanho');

    if (documents.length == 0) {
      final QuerySnapshot result2 = await db
          .collection('piramides')
          .where('nome', isEqualTo: autocomplete)
          .getDocuments();
      documents = result2.documents;
      // print(documents.length.toString() + 'tamanho22222222222222');

    }

    List<Piramide> l = [];
    documents.forEach((data) {
      //  print(data.data['dataInicio'] + 'NNNOOOOMMMEEE');
      l.add(Piramide.fromMap(data.data, data.documentID));
    });
    listPiram = l;
    // print(l.length.toString() + 'lenth');

    piramidesEvent.add(listPiram);
  }

  // Future<String> salvarNovaPiramide() async {

  //   return null;
  // }

  void aceitarUsuario(String piramideId) async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    DocumentSnapshot result =
        await db.collection('usuarios').document(uid).get();

    Usuario user1 = Usuario.fromMap(result.data, result.documentID);

    if (!user1.piramidesPodeRelatarId.contains(piramideId)) {
      user1.piramidesPodeRelatarId.add(piramideId);
      await db.collection('usuarios').document(uid).updateData(user1.toMap());
    }
  }

  void novoPedido(String piramideId) async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    //todo singleton usuario
    DocumentSnapshot rr = await db.collection('usuarios').document(uid).get();
    Usuario user1 = Usuario.fromMap(rr.data, rr.documentID);
    await db.collection('pedidos').document().setData(Pedido(
            usuarioId: uid,
            situacaoPedido: pedidosEnum.aberto,
            piramideId: piramideId,
            nome: user1.nome,
            data: DateTime.now().toIso8601String())
        .toMap());

    // DocumentReference pedidosDoc = await db.collection('pedidos').document();

    // await db
    //     .collection('pedidos')
    //     .document(pedidosDoc.documentID)
    //     .setData(Pedido(usuarioID: uid, piramideID: piramideId).toMap());
  }

  @override
  void dispose() {
    piramidesController.close();
    // camadasController.close();
    // camadaSelecinadaController.close();
    // piramideController.close();
    // cpiController.close();
    super.dispose();
  }
}
