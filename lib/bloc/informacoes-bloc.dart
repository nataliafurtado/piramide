import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/camada-info.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/pergunta-relato.dart';
import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class InformacoesBloc extends BlocBase {
  InformacoesBloc();

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

  // static List<Pergunta> listPerg = [
  //   Pergunta(obrigatoria: false, perguntaTitulo: '')
  // ];
  // static List<PerguntaRelato> lll = [
  //   PerguntaRelato(obrigatoria: false, perguntaTitulo: '')
  // ];

  // var perguntasController = BehaviorSubject<List<Pergunta>>.seeded(listPerg);
  // Observable<List<Pergunta>> get perguntasFluxo => perguntasController.stream;
  // Sink<List<Pergunta>> get perguntasEvent => perguntasController.sink;

  var informacoesController = BehaviorSubject<Informacoes>();
  Observable<Informacoes> get informacoesFluxo => informacoesController.stream;
  Sink<Informacoes> get informacoesEvent => informacoesController.sink;

  void salvar() async {
    await db
        .collection('informacoes')
        .document(informacoesController.value.informacoesId)
        .updateData(informacoesController.value.toMap());
  }

  void calculaPoscentagemPiramide(Piramide piramide, Informacoes informacoes) {
    Periodo peri = informacoes.periodos.where((periodo) {
      if (periodo.geral = true) {
        return true;
      } else {
        return false;
      }
    }).first;

    int total = peri.totalTodasAsCamadas;
    // print(total.toString() + 'totalTodasAsCamadas');
    for (var i = 0; i < piramide.camadasDaPiramide.length; i++) {
      // print(peri.camadasInfo[i].totalCamada.toString() + 'totalcamada');
      double f = (peri.camadasInfo[i].totalCamada / total) * 100;
      double n = num.parse(f.toStringAsFixed(1));
      if (total == 0) {
        n = 0;
      }
      piramide.camadasDaPiramide[i].porcentagem = n;
    }

    for (var i = 0; i < informacoes.periodos.length; i++) {
      int total = informacoes.periodos[i].totalTodasAsCamadas;
      for (var ii = 0; ii < informacoes.periodos[i].camadasInfo.length; ii++) {
        double f =
            (informacoes.periodos[i].camadasInfo[ii].totalCamada / total) * 100;
        double n = num.parse(f.toStringAsFixed(1));
        if (total == 0) {
          n = 0;
        }
        informacoes.periodos[i].camadasInfo[ii].porcentagem = n;
      }
    }
  }

  void carregaInfo(Piramide piramide) async {
    QuerySnapshot rrr = await db
        .collection('informacoes')
        .where('piramideId', isEqualTo: piramide.piramideId)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = rrr.documents;
    if (documents.isEmpty) {
      // print('return');
      return;
    }

    // print(documents[0].data);
    Informacoes infor =
        Informacoes.fromMap(documents[0].data, documents[0].documentID);
    calculaPoscentagemPiramide(piramide, infor);
    informacoesEvent.add(infor);
    // print(infor.periodos.length.toString()+'lengh peirodo');
    // for (var i = 0; i < infor.periodos.length; i++) {

    // }
  }

  void novoPeriodo(Piramide piramide) {
    Periodo pe = Periodo(
        dataInicio: DateTime.now().toIso8601String(),
        camadasInfo: [],
        geral: false,
        totalTodasAsCamadas: 0);
    for (var i = 0; i < piramide.camadasDaPiramide.length; i++) {
      pe.camadasInfo.add(CamadaInfo(camada: i, totalCamada: 0, porcentagem: 0));
    }
    informacoesController
        .value
        .periodos[informacoesController.value.periodos.length - 1]
        .dataFim = DateTime.now().toIso8601String();
    informacoesController.value.nperiodos =
        informacoesController.value.nperiodos + 1;
    informacoesController.value.periodos.add(pe);
    informacoesEvent.add(informacoesController.value);
  }

  void novoRelato(Piramide piramideId, int numerocamada) async {
    // final FirebaseUser user = await _auth.currentUser();
    // final String uid = user.uid;

    // Relato relato = Relato(
    //   piramideId: piramideId.piramideId,
    //   datacriacao: DateTime.now().toIso8601String(),
    //   numeroCamada: numerocamada,
    //   qtdPerguntas: informacoesController.value.length,
    //   usuarioRelatouId: uid,
    //   informacoes: [],
    // );

//     relato.informacoes.addAll(informacoesController.value);

//     DocumentReference relatoDoc = await db.collection('relatos').document();

//     await db
//         .collection('relatos')
//         .document(relatoDoc.documentID)
//         .setData(relato.toMap());

// piramideId.camadasDaPiramide[numerocamada].total=piramideId.camadasDaPiramide[numerocamada].total+1;
//     await db
//         .collection('piramides')
//         .document(piramideId.piramideId)
//         .updateData(piramideId.toMap());

//   }

//   void carregaPerguntas(String documentIDPiramide, int camadaIndex) async {
//     final FirebaseUser user = await _auth.currentUser();
//     final String uid = user.uid;
//     final QuerySnapshot result = await db
//         .collection('piramides')
//         .document(documentIDPiramide)
//         .collection('perguntasPiramide')
//         .where('ncamada', isEqualTo: camadaIndex.toString())
//         .getDocuments();
//     final List<DocumentSnapshot> documents = result.documents;

//     // List<Pergunta> l = [];
//     List<PerguntaRelato> lpr = [];
//     documents.forEach((data) {
//       // l.add(Pergunta.fromMap(data.data, data.documentID));
//       lpr.add(PerguntaRelato.fromMapDePergunta(data.data, data.documentID));
//     });
// //listPerg = l;
//     lll = lpr;
//     print(lll.length.toString() + 'tamanho lll  ll ');
//     //  print(camadaIndex.toString() +' :  camadaindex');
//     // perguntasEvent.add(listPerg);
//     informacoesEvent.add(lll);
  }

  @override
  void dispose() {
    informacoesController.close();

    super.dispose();
  }

  void recalcularInfoPeriodo(int periIndex) async {
    final QuerySnapshot result = await db
        .collection('relatos')
        .where('datacriacao',
            isGreaterThan:
                informacoesController.value.periodos[periIndex].dataInicio)
        .where('datacriacao',
            isLessThan: informacoesController.value.periodos[periIndex].dataFim)
        .where('piramideId', isEqualTo: informacoesController.value.piramideId)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    // List<Pergunta> l = [];
    List<Relato> lpr = [];
    documents.forEach((data) {
      // l.add(Pergunta.fromMap(data.data, data.documentID));
      lpr.add(Relato.fromMap(data.data,data.documentID));
    });
    print(informacoesController.value.periodos[periIndex].dataInicio +
        '  : inicio');
    print(informacoesController.value.periodos[periIndex].dataFim + '  : fim');

    _zerarDadosPerido(periIndex);

    informacoesController.value.periodos[periIndex].totalTodasAsCamadas =
        lpr.length;

    for (var i = 0; i < lpr.length; i++) {
      //  print(lpr[i].piramideId + '   : dat creiacao');

      for (var iii = 0;
          iii <
              informacoesController
                  .value.periodos[periIndex].camadasInfo.length;
          iii++) {
        if (lpr[i].numeroCamada ==
            informacoesController
                .value.periodos[periIndex].camadasInfo[iii].camada) {
          informacoesController.value.periodos[periIndex].camadasInfo[iii]
              .totalCamada = informacoesController
                  .value.periodos[periIndex].camadasInfo[iii].totalCamada +
              1;
        }
      }
    }
    informacoesEvent.add(informacoesController.value);
    //  print(lpr.length.toString() + '     : ddddedd3e3e3e3e3e3e3');
  }

  void _zerarDadosPerido(int periIndex) {
    informacoesController.value.periodos[periIndex].totalTodasAsCamadas = 0;
    for (var i = 0;
        i < informacoesController.value.periodos[periIndex].camadasInfo.length;
        i++) {
      informacoesController
          .value.periodos[periIndex].camadasInfo[i].totalCamada = 0;
    }
    // informacoesEvent.add(informacoesController.value);
  }
}
