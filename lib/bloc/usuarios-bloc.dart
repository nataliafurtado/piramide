import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/pedido.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class UsuariosBloc extends BlocBase {
  UsuariosBloc();

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

  static List<Relato> list = [];

  var usuariosController = BehaviorSubject<List<Usuario>>.seeded([]);
  Observable<List<Usuario>> get usuariosFluxo => usuariosController.stream;
  Sink<List<Usuario>> get usuariosEvent => usuariosController.sink;

  static TextEditingController ff = TextEditingController(text: '');

  var txController = BehaviorSubject<TextEditingController>.seeded(ff);
  Observable<TextEditingController> get txFluxo => txController.stream;
  Sink<TextEditingController> get txEvent => txController.sink;

  String usuaId = null;

  void carregaRelatos(
      String usuarioId, String piramideId, int camada, Periodo periodo) async {
    usuaId = usuarioId;
    List<DocumentSnapshot> documents;
    if (periodo == null) {
      final QuerySnapshot result = await db
          .collection('relatos')
          .where('usuarioRelatouId', isEqualTo: usuarioId)
          .where('piramideId', isEqualTo: piramideId)
          .where('numeroCamada', isEqualTo: camada)
          .orderBy('datacriacao', descending: true)
          .limit(5)
          .getDocuments();

      documents = result.documents;
    } else {
      String dataFim;
      if (periodo.dataFim == null) {
        dataFim = DateTime.now().add(Duration(days: 1)).toIso8601String();
      } else {
        dataFim = periodo.dataFim;
      }

      final QuerySnapshot result = await db
          .collection('relatos')
          .where('usuarioRelatouId', isEqualTo: usuarioId)
          .where('piramideId', isEqualTo: piramideId)
          .where('numeroCamada', isEqualTo: camada)
          .orderBy('datacriacao', descending: true)
          .limit(5)
          .startAfter([dataFim]).endAt([periodo.dataInicio]).getDocuments();

      documents = result.documents;
    }

    List<Relato> l = [];
    documents.forEach((data) {
      l.add(Relato.fromMap(data.data,data.documentID));
    });
    list = l;
    // print(l.length.toString() + 'lenth');

    // relatoEvent.add(list);
//print('depos');
    // for (var i = 0; i < l.length; i++) {
    //   print(l[i].datacriacao);
    // }
  }

  void carregaMaisRelatos(
      String piramideId, int camada, Periodo periodo) async {
    List<DocumentSnapshot> documents;
    QuerySnapshot result;
    if (periodo == null) {
      result = await db
          .collection('relatos')
          .where('piramideId', isEqualTo: piramideId)
          .where('numeroCamada', isEqualTo: camada)
          .orderBy('datacriacao', descending: true)
          .limit(5)
          .startAfter([list.last.datacriacao]).getDocuments();
    } else {
      if (usuaId == null) {
        result = await db
            .collection('relatos')
            .where('piramideId', isEqualTo: piramideId)
            .where('numeroCamada', isEqualTo: camada)
            .orderBy('datacriacao', descending: true)
            .limit(5)
            .startAfter([list.last.datacriacao]).endAt(
                [periodo.dataInicio]).getDocuments();
      } else {
        result = await db
            .collection('relatos')
            .where('usuarioRelatouId', isEqualTo: usuaId)
            .where('piramideId', isEqualTo: piramideId)
            .where('numeroCamada', isEqualTo: camada)
            .orderBy('datacriacao', descending: true)
            .limit(5)
            .startAfter([list.last.datacriacao]).endAt(
                [periodo.dataInicio]).getDocuments();
      }
    }

    documents = result.documents;

    List<Relato> l = [];
    documents.forEach((data) {
      l.add(Relato.fromMap(data.data,data.documentID));
    });
    list.addAll(l);
  }

  void carregaVazio(String piramideId) async {
    // print(piramideId);
    final QuerySnapshot result = await db
        .collection('usuarios')
        .where('piramidesPodeRelatarId', arrayContains: piramideId)
        //.orderBy('nome')
        .limit(10)
        .getDocuments();
    List<DocumentSnapshot> documents = result.documents;

    List<Usuario> l = [];
    documents.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    usuariosEvent.add(l);
  }

  @override
  void dispose() {
    txController.value.text = '';
    txEvent.add(txController.value);
    txController.close();
   // print('fechou controller tx ');
    usuariosController.close();
    super.dispose();
  }

  void carregaUsuarios(String autocomplete, String piramideId) async {
   // autocomplete = 'Natá';
    final QuerySnapshot result = await db
        .collection('usuarios')
        .where('nome', isGreaterThan: autocomplete)
        .where('nome', isLessThan: autocomplete + 'z')
        .where('piramidesPodeRelatarId', arrayContains: piramideId)
        .orderBy('nome')
        .limit(10)
        .getDocuments();
    List<DocumentSnapshot> documents = result.documents;

      print(' sssssss   : '+documents.length.toString()+piramideId+autocomplete);

    List<Usuario> l = [];
    documents.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    usuariosEvent.add(l);
    // for (var i = 0; i < l.length; i++) {
    //   print(l[i].nome);
    // }
  }

  void excluirUsuario(String piramideId, int indexUsuarios) async {
    Usuario user = usuariosController.value[indexUsuarios];
    user.piramidesPodeRelatarId.removeWhere((t) => t == piramideId);
    await db
        .collection('usuarios')
        .document(usuariosController.value[indexUsuarios].usuarioId)
        .updateData(user.toMap());
  }
}
