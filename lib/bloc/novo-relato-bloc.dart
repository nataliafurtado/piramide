import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/camada.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/pedido.dart';
import 'package:comportamentocoletivo/model/pergunta-relato.dart';
import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class NovoRelatoBloc extends BlocBase {
  NovoRelatoBloc();

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

  static List<Pergunta> listPerg = [
    Pergunta(obrigatoria: false, perguntaTitulo: '')
  ];
  static List<PerguntaRelato> lll = [
    PerguntaRelato(obrigatoria: false, perguntaTitulo: '')
  ];

  // var perguntasController = BehaviorSubject<List<Pergunta>>.seeded(listPerg);
  // Observable<List<Pergunta>> get perguntasFluxo => perguntasController.stream;
  // Sink<List<Pergunta>> get perguntasEvent => perguntasController.sink;

  var perguntasRelatoController =
      BehaviorSubject<List<PerguntaRelato>>.seeded(lll);
  Observable<List<PerguntaRelato>> get perguntasRelatoFluxo =>
      perguntasRelatoController.stream;
  Sink<List<PerguntaRelato>> get perguntasRelatoEvent =>
      perguntasRelatoController.sink;

  var usuariosController = BehaviorSubject<List<Usuario>>.seeded([]);
  Observable<List<Usuario>> get usuariosFluxo => usuariosController.stream;
  Sink<List<Usuario>> get usuariosEvent => usuariosController.sink;

  Future<String> novoRelato(Piramide piramideId, int numerocamada) async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;

    // for (var i = 0; i < perguntasRelatoController.value.length; i++) {
    //   if (perguntasRelatoController.value[i].obrigatoria &&
    //       (perguntasRelatoController.value[i].resposta == null ||
    //           perguntasRelatoController.value[i].resposta.isEmpty)) {
    //     return 'Todas a perguntas obrigatórias devem ser respondidas';
    //   }
    // }
//pega usuario
    DocumentSnapshot result =
        await db.collection('usuarios').document(uid).get();
    Usuario user1 = Usuario.fromMap(result.data, result.documentID);
//carrega relato
    Relato relato = Relato(
      piramideId: piramideId.piramideId,
      datacriacao: DateTime.now().toIso8601String(),
      numeroCamada: numerocamada,
      qtdPerguntas: perguntasRelatoController.value.length,
      usuarioRelatouId: uid,
      usarioNome: user1.nome,
      perguntasRelato: [],
    );

    relato.perguntasRelato.addAll(perguntasRelatoController.value);

    DocumentReference relatoDoc = await db.collection('relatos').document();

    await db
        .collection('relatos')
        .document(relatoDoc.documentID)
        .setData(relato.toMap());

    piramideId.camadasDaPiramide[numerocamada].total =
        piramideId.camadasDaPiramide[numerocamada].total + 1;
    await db
        .collection('piramides')
        .document(piramideId.piramideId)
        .updateData(piramideId.toMap());

    //informacoes

    QuerySnapshot rrr = await db
        .collection('informacoes')
        .where('piramideId', isEqualTo: piramideId.piramideId)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = rrr.documents;

    Informacoes infor =
        Informacoes.fromMap(documents[0].data, documents[0].documentID);

    infor = _addNovoRelatoNasInfo(infor, numerocamada);

    // print('bbbbbbbbbbbbbbbbbbbbb');
    //  print( documents[0].data['piramideId']);
    // documents.forEach((data) {
    //   l.add(Piramide.fromMap(data.data, data.documentID));
    // });
//    Pedido pedi = Pedido.fromMap(rrr.data);

    await db
        .collection('informacoes')
        .document(documents[0].documentID)
        .updateData(infor.toMap());

    return null;
  }

  void carregaUsuarios(String autocomplete, String piramideId) async {
    print(piramideId + 'piramideIdpiramideIdpiramideId');
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

    print(' sssssss   : ' +
        documents.length.toString() +
        piramideId +
        autocomplete);

    List<Usuario> l = [];
    documents.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    // denovo inteiro

    final QuerySnapshot result0 = await db
        .collection('usuarios')
        .where('nome', isEqualTo: autocomplete)
        .where('piramidesPodeRelatarId', arrayContains: piramideId)        
        .limit(10)
        .getDocuments();
    List<DocumentSnapshot> documents0 = result0.documents;

    documents0.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    final QuerySnapshot result1 = await db
        .collection('usuarios')
        .where('nome', isGreaterThan: autocomplete)
        .where('nome', isLessThan: autocomplete + 'z')
        .where('piramidesAdmnistra', arrayContains: piramideId)
        .orderBy('nome')
        .limit(10)
        .getDocuments();
    List<DocumentSnapshot> documents1 = result1.documents;

    // print(' ffffff   : ' +
    //     documents1.length.toString() +
    //     piramideId +
    //     autocomplete);

    documents1.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    // denovo inteor

    final QuerySnapshot result3 = await db
        .collection('usuarios')
        .where('nome', isEqualTo: autocomplete)
        .where('piramidesAdmnistra', arrayContains: piramideId)
        .limit(10)
        .getDocuments();
    List<DocumentSnapshot> documents3 = result3.documents;

    documents3.forEach((data) {
      l.add(Usuario.fromMap(data.data, data.documentID));
    });

    usuariosEvent.add(l);
  }

  void carregaPerguntas(String documentIDPiramide, int camadaIndex) async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    final QuerySnapshot result = await db
        .collection('piramides')
        .document(documentIDPiramide)
        .collection('perguntasPiramide')
        .where('ncamada', isEqualTo: camadaIndex.toString())
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    // List<Pergunta> l = [];
    List<PerguntaRelato> lpr = [];
    documents.forEach((data) {
      // l.add(Pergunta.fromMap(data.data, data.documentID));
      lpr.add(PerguntaRelato.fromMapDePergunta(data.data, data.documentID));
    });
//listPerg = l;
    lll = lpr;
    //  print(lll.length.toString() + 'tamanho lll  ll ');
    //  print(camadaIndex.toString() +' :  camadaindex');
    // perguntasEvent.add(listPerg);
    perguntasRelatoEvent.add(lll);
  }

  @override
  void dispose() {
    perguntasRelatoController.close();
    usuariosController.close();
    // camadasController.close();
    // camadaSelecinadaController.close();
    // piramideController.close();
    // cpiController.close();
    super.dispose();
  }

  Informacoes _addNovoRelatoNasInfo(Informacoes infor, int numerocamada) {
    //infor.periodos[0].totalTodasAsCamadas=infor.periodos[0].totalTodasAsCamadas+1;
    //todo  verificar qual o periodo q esta no praso
    //print('lenght'+infor.periodos.length.toString());
    for (var i = 0; i < infor.periodos.length; i++) {
      if (infor.periodos[i].geral) {
        infor.periodos[i].totalTodasAsCamadas =
            infor.periodos[i].totalTodasAsCamadas + 1;
        for (var idd = 0; idd < infor.periodos[i].camadasInfo.length; idd++) {
          if (infor.periodos[i].camadasInfo[idd].camada == numerocamada) {
            infor.periodos[i].camadasInfo[numerocamada].totalCamada =
                infor.periodos[i].camadasInfo[numerocamada].totalCamada + 1;
          }
        }
      }
      // print('tgtgtgtgtgtgtgtg');
      // print(infor.periodos[i].dataInicio);
      // print(infor.periodos[i].dataFim);
      //sempre vai colocar no aberto
      if (infor.periodos[i].dataInicio != null &&
          infor.periodos[i].dataFim == null) {
        infor.periodos[i].totalTodasAsCamadas =
            infor.periodos[i].totalTodasAsCamadas + 1;
        for (var idd = 0; idd < infor.periodos[i].camadasInfo.length; idd++) {
          if (infor.periodos[i].camadasInfo[idd].camada == numerocamada) {
            infor.periodos[i].camadasInfo[numerocamada].totalCamada =
                infor.periodos[i].camadasInfo[numerocamada].totalCamada + 1;
          }
        }
      }
    }
    return infor;
  }

  void colocaNomeUsuarioNaResposta(int indexUsuarios, int indexPergunta) {
    perguntasRelatoController.value[indexPergunta].resposta =
        usuariosController.value[indexUsuarios].nome;
    //  perguntasRelatoEvent.add(perguntasRelatoController.value);
  }
}
