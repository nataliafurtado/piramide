import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/pedido.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class VerRelatosBloc extends BlocBase {
  VerRelatosBloc();

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

  var relatosController = BehaviorSubject<List<Relato>>.seeded(list);
  Observable<List<Relato>> get realatoFluxo => relatosController.stream;
  Sink<List<Relato>> get relatoEvent => relatosController.sink;

  var usuariosController = BehaviorSubject<List<Usuario>>.seeded([]);
  Observable<List<Usuario>> get usuariosFluxo => usuariosController.stream;
  Sink<List<Usuario>> get usuariosEvent => usuariosController.sink;

  static TextEditingController ff = TextEditingController(text: '');

  var txController = BehaviorSubject<TextEditingController>.seeded(ff);
  Observable<TextEditingController> get txFluxo => txController.stream;
  Sink<TextEditingController> get txEvent => txController.sink;

  var usuariosVisivelController = BehaviorSubject<bool>.seeded(true);
  Observable<bool> get usuariosVisivelFluxo => usuariosVisivelController.stream;
  Sink<bool> get usuariosVisivelEvent => usuariosVisivelController.sink;

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
      l.add(Relato.fromMap(data.data, data.documentID));
    });
    list = l;
    // print(l.length.toString() + 'lenth');

    relatoEvent.add(list);
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
      l.add(Relato.fromMap(data.data, data.documentID));
    });
    list.addAll(l);

    relatoEvent.add(list);
  }

  String usuarioOnlineId;
  void carregaUsuarioId() async {
    final FirebaseUser user = await _auth.currentUser();
    usuarioOnlineId = user.uid;
  }

  void carregaRelatosVazio(
      String piramideId, int camada, Periodo periodo) async {
    List<DocumentSnapshot> documents;
    if (periodo == null) {
      final QuerySnapshot result = await db
          .collection('relatos')
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
          .where('piramideId', isEqualTo: piramideId)
          .where('numeroCamada', isEqualTo: camada)
          .orderBy('datacriacao', descending: true)
          .limit(5)
          .startAfter([dataFim]).endAt([periodo.dataInicio]).getDocuments();
      documents = result.documents;
    }

    List<Relato> l = [];
    //print(documents.length);
    if (documents!=null) {
        documents.forEach((data) {
          // print('tgtgtgtgtg');
          // print(data.data);
      l.add(Relato.fromMap(data.data, data.documentID));
    });
    list = l;

    relatoEvent.add(list);
    }
  
  }

  @override
  void dispose() {
    relatosController.close();
    txController.close();
    usuariosController.close();
    usuariosVisivelController.close();
    super.dispose();
  }

  void carregaUmUsuariDeRelatos(
      String autocomplete, String piramideId, int camada) async {
    final QuerySnapshot result = await db
        .collection('usuarios')
        .where('nome', isGreaterThan: autocomplete)
        .where('nome', isLessThan: autocomplete + 'z')
        .where('piramidesPodeRelatarId', arrayContains: piramideId)
        .orderBy('nome')
        .limit(6)
        .getDocuments();
    List<DocumentSnapshot> documents = result.documents;

    //  print(documents.length);

    List<Usuario> l = [];
    documents.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    usuariosEvent.add(l);
    // for (var i = 0; i < l.length; i++) {
    //   print(l[i].nome);
    // }
  }

  void excluirRelato(Relato relato, Piramide piramide, Informacoes info) async {
// se for o ultimo periodo tirar da piramide
    _tirarDaPiramideSeDentroPeriodo(relato, piramide, info);

    await db
        .collection('piramides')
        .document(piramide.piramideId)
        .updateData(piramide.toMap());

    info = _excluirRelatoDaInfo(info, relato);
    await db
        .collection('informacoes')
        .document(info.informacoesId)
        .updateData(info.toMap());

    await db.collection('relatos').document(relato.relatoId).delete();
  }

  void _tirarDaPiramideSeDentroPeriodo(
      Relato relato, Piramide piramide, Informacoes infor) {
    Periodo per = infor.periodos
        .firstWhere((inf) => inf.dataInicio != null && inf.dataFim == null);
    DateTime inicio = DateTime.parse(per.dataInicio);
    DateTime criacao = DateTime.parse(relato.datacriacao);
    if (inicio.isBefore(criacao)) {
      piramide.camadasDaPiramide[relato.numeroCamada].total =
          piramide.camadasDaPiramide[relato.numeroCamada].total - 1;
    }
  }

  Informacoes _excluirRelatoDaInfo(Informacoes infor, Relato relato) {
    int numerocamada = relato.numeroCamada;
    for (var i = 0; i < infor.periodos.length; i++) {
      if (infor.periodos[i].geral) {
        infor.periodos[i].totalTodasAsCamadas =
            infor.periodos[i].totalTodasAsCamadas - 1;
        for (var idd = 0; idd < infor.periodos[i].camadasInfo.length; idd++) {
          if (infor.periodos[i].camadasInfo[idd].camada == numerocamada) {
            infor.periodos[i].camadasInfo[numerocamada].totalCamada =
                infor.periodos[i].camadasInfo[numerocamada].totalCamada - 1;
          }
        }
      } else {
        //print(infor.periodos[i].dataInicio);
        DateTime inicio = DateTime.parse(infor.periodos[i].dataInicio);
        DateTime fim;
        if (infor.periodos[i].dataFim == null) {
          fim = DateTime.now();
        } else {
          fim = DateTime.parse(infor.periodos[i].dataFim);
        }
        DateTime criacao = DateTime.parse(relato.datacriacao);
        print('craicai   : ' + relato.datacriacao);
        if (inicio.isBefore(criacao) && fim.isAfter(criacao)) {
          infor.periodos[i].totalTodasAsCamadas =
              infor.periodos[i].totalTodasAsCamadas - 1;
          for (var idd = 0; idd < infor.periodos[i].camadasInfo.length; idd++) {
            if (infor.periodos[i].camadasInfo[idd].camada == numerocamada) {
              infor.periodos[i].camadasInfo[numerocamada].totalCamada =
                  infor.periodos[i].camadasInfo[numerocamada].totalCamada - 1;
            }
          }
        }
      }
    }
    return infor;
  }
}
