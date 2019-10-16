import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/camada-info.dart';
import 'package:comportamentocoletivo/model/camada.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/ui/informacoes-ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:rxdart/rxdart.dart';

class NovaPiramideBLoc extends BlocBase {
  NovaPiramideBLoc();

  final cpiController = BehaviorSubject<bool>.seeded(false);
  Observable<bool> get cpiFluxo => cpiController.stream;
  Sink<bool> get cpiEvent => cpiController.sink;

  //final  Piramide p = Piramide(nome: 'hhhh');

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final piramideController = BehaviorSubject<Piramide>.seeded(Piramide(
      camadasDaPiramide: [], dataInicio: DateTime.now().toIso8601String()));
  Observable<Piramide> get piramideFluxo => piramideController.stream;
  Sink<Piramide> get piramideEvent => piramideController.sink;

  final camadaSelecinadaController = BehaviorSubject<int>.seeded(0);
  Observable<int> get camadaSelecinadaFluxo =>
      camadaSelecinadaController.stream;
  Sink<int> get camadaSelecinadaEvent => camadaSelecinadaController.sink;

  static List<Camada> list = [
    Camada(nome: 'Camada 1 ', perguntaDaCamada: [
      Pergunta(
        perguntaEnum: perguntasEnum.como,
        perguntaTitulo: 'perg tituolde',
      ),
    ]),
    Camada(nome: 'Camada 2', perguntaDaCamada: [
      Pergunta(perguntaEnum: perguntasEnum.como, perguntaTitulo: 'perg leve1'),
      Pergunta(perguntaEnum: perguntasEnum.como, perguntaTitulo: 'perg le2'),
    ]),
    Camada(nome: 'Camada 3', perguntaDaCamada: [
      Pergunta(perguntaEnum: perguntasEnum.como, perguntaTitulo: 'inc inc'),
      Pergunta(perguntaEnum: perguntasEnum.como, perguntaTitulo: 'inc le2'),
      Pergunta(perguntaEnum: perguntasEnum.como, perguntaTitulo: 'inc leve33'),
    ]),
    // Camada(nome: 'Ato Inseguro', perguntaDaCamada: [
    //   Pergunta(perguntaTitulo: 'perg leve1'),
    //   Pergunta(perguntaTitulo: 'perg le2'),
    //   Pergunta(perguntaTitulo: 'perg leve33'),
    // ]),
    // Camada(nome: 'Condição Insegura', perguntaDaCamada: [
    //   Pergunta(perguntaTitulo: 'perg leve1'),
    //   Pergunta(perguntaTitulo: 'perg le2'),
    //   Pergunta(perguntaTitulo: 'perg leve33'),
    // ]),
  ];

  void carregaModelo(piramidesModeloEnum modelo) {
    print(modelo.toString());

    if (modelo == piramidesModeloEnum.birt) {
      list = [
        Camada(nome: 'Fatalidades (Morte) ', perguntaDaCamada: [
          Pergunta(
            perguntaEnum: perguntasEnum.como,
           
          ),
        ]),
        Camada(nome: 'Acidentes com afastamento', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Acidente sem afastamento', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Incidentes (quase acidentes)', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Condição ou ato inseguro', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
      ];
    } else if (modelo == piramidesModeloEnum.lgbtfobia) {
      list = [
        Camada(nome: 'Mortes', perguntaDaCamada: [
          Pergunta(
            perguntaEnum: perguntasEnum.como,
            perguntaTitulo: 'perg tituolde',
          ),
        ]),
        Camada(nome: 'Violência Grave,Estupro', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Ameaça,Agressão Verbal', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Marginalização , Desumanização , Humiliação', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        Camada(nome: 'Objetificação, Piadas, Termos Pejorativos', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
      ];
    } else if (modelo == piramidesModeloEnum.generica) {
      list = [
        Camada(nome: 'Camada 1 ', perguntaDaCamada: [
          Pergunta(
            perguntaEnum: perguntasEnum.como,
          ),
        ]),
        Camada(nome: 'Camada 2', perguntaDaCamada: [
          Pergunta(
            perguntaEnum: perguntasEnum.como,
          ),
          Pergunta(
            perguntaEnum: perguntasEnum.como,
          ),
        ]),
        Camada(nome: 'Camada 3', perguntaDaCamada: [
          Pergunta(perguntaEnum: perguntasEnum.como),
          Pergunta(
            perguntaEnum: perguntasEnum.como,
          ),
          Pergunta(perguntaEnum: perguntasEnum.como),
        ]),
        // Camada(nome: 'Ato Inseguro', perguntaDaCamada: [
        //   Pergunta(perguntaTitulo: 'perg leve1'),
        //   Pergunta(perguntaTitulo: 'perg le2'),
        //   Pergunta(perguntaTitulo: 'perg leve33'),
        // ]),
        // Camada(nome: 'Condição Insegura', perguntaDaCamada: [
        //   Pergunta(perguntaTitulo: 'perg leve1'),
        //   Pergunta(perguntaTitulo: 'perg le2'),
        //   Pergunta(perguntaTitulo: 'perg leve33'),
        // ]),
      ];
    }
    camadaEvent.add(list);
  }

  var camadasController = BehaviorSubject<List<Camada>>.seeded(list);
  Observable<List<Camada>> get camadaFluxo => camadasController.stream;
  Sink<List<Camada>> get camadaEvent => camadasController.sink;

  String _validacaoSalvarPiramide() {
    if (piramideController.value.nome == null ||
        piramideController.value.nome.isEmpty) {
      return 'É obrigatório informar um nome';
    }

    if (piramideController.value.nome.length < 2) {
      return 'Nome não pode ser menor de três digitos';
    }

    for (var i = 0; i < camadasController.value.length; i++) {
      for (var iw = 0;
          iw < camadasController.value[i].perguntaDaCamada.length;
          iw++) {
        if (camadasController.value[i].perguntaDaCamada[iw].perguntaEnum ==
            null) {
          return 'A pergunta nº $iw da camada nº $i está em branco.';
        }
      }
    }

    return null;
  }

  Future<String> salvarNovaPiramide() async {
    String retorno = _validacaoSalvarPiramide();
    if (retorno != null) {
      return retorno;
    }
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;

    DocumentReference piramideDoc = await db
        // .collection('usuarios')
        // .document(uid)
        .collection('piramides')
        .document();

    for (var indexCamada = 0;
        indexCamada < camadasController.value.length;
        indexCamada++) {
      piramideController.value.camadasDaPiramide
          .add(camadasController.value[indexCamada]);

      for (var ii = 0;
          ii < camadasController.value[indexCamada].perguntaDaCamada.length;
          ii++) {
        DocumentReference perguntaDoc = await db
            // .collection('usuarios')
            // .document(uid)
            .collection('piramides')
            .document(piramideDoc.documentID)
            .collection('perguntasPiramide')
            .document();

        await db
            // .collection('usuarios')
            // .document(uid)
            .collection('piramides')
            .document(piramideDoc.documentID)
            .collection('perguntasPiramide')
            .document(perguntaDoc.documentID)
            .setData(camadasController.value[indexCamada].perguntaDaCamada[ii]
                .toMap(indexCamada));
      }
    }

    await db
        // .collection('usuarios')
        // .document(uid)
        .collection('piramides')
        .document(piramideDoc.documentID)
        .setData(piramideController.value.toMap(uid: uid));

    camadaSelecinadaEvent.add(0);
    //  print('veiouuuu');
    piramideEvent.add(Piramide());
    // camadasController.on

    DocumentReference infoDoc = await db.collection('informacoes').document();
    Periodo geral = Periodo(
      camadasInfo: [],
      totalTodasAsCamadas: 0,
    );
    Periodo periodoInicio = Periodo(
      dataInicio: DateTime.now().toIso8601String(),
      camadasInfo: [],
      totalTodasAsCamadas: 0,
    );

    for (var indexCamada = 0;
        indexCamada < camadasController.value.length;
        indexCamada++) {
      geral.camadasInfo.add(CamadaInfo(totalCamada: 0, camada: indexCamada));
      periodoInicio.camadasInfo.add(CamadaInfo(
        totalCamada: 0,
        camada: indexCamada,
      ));
    }
    List<Periodo> listPeriodo = [geral, periodoInicio];
    Informacoes info = Informacoes(
        piramideId: piramideDoc.documentID,
        periodos: listPeriodo,
        nperiodos: 2,
        numeroCamadas: camadasController.value.length);

    await db
        .collection('informacoes')
        .document(infoDoc.documentID)
        .setData(info.toMap());

    //camadasController = BehaviorSubject<List<Camada>>.seeded(list2);
    //list.clear();
    // list = list2;

    // camadaEvent.add(list);
    // print('recem mudou ');
    // print(camadasController.value.length);

    return null;
  }

  int perguntasLength() {
    return camadasController
        .value[camadaSelecinadaController.value].perguntaDaCamada.length;
  }

  Camada camadaSelecionada() {
    return camadasController.value[camadaSelecinadaController.value];
  }

  alteraCheckBox(int ind, bool obrigatoriaCheck) {
    // print(!obrigatoriaCheck);
    camadasController.value[camadaSelecinadaController.value]
        .perguntaDaCamada[ind].obrigatoria = obrigatoriaCheck;
    camadaEvent.add(camadasController.value);
  }

  @override
  void dispose() {
    //  _nomeController.close();
    camadasController.close();
    camadaSelecinadaController.close();
    piramideController.close();
    cpiController.close();
    super.dispose();
  }

  void alteraPergunta(int ind, perguntasEnum novoEnum) {
    camadasController.value[camadaSelecinadaController.value]
        .perguntaDaCamada[ind].perguntaEnum = novoEnum;
    camadaEvent.add(camadasController.value);
  }

  void atualizarMerda() {
    camadaEvent.add(camadasController.value);
  }

  void removerPergunta(int ind) {
    //  print(camadasController.value[camadaSelecinadaController.value].perguntaDaCamada.length);
    camadasController.value[camadaSelecinadaController.value].perguntaDaCamada
        .removeAt(ind);
    //    print(camadasController.value[camadaSelecinadaController.value].perguntaDaCamada.length);
    camadaEvent.add(camadasController.value);
  }

  void addNovaPergunta() {
    camadasController.value[camadaSelecinadaController.value].perguntaDaCamada
        .add(Pergunta(perguntaTitulo: 'perg le2'));
    camadaEvent.add(camadasController.value);
  }

  void addNovaCamada() {
    // print(camadasController.value.length);
    // if (camadasController.value.length>5) {
    //   print('não entrou');
    //   return;
    // }
    camadasController.value.add(
      Camada(nome: 'Nova Camada', perguntaDaCamada: [
        Pergunta(perguntaTitulo: 'addd leve1'),
        Pergunta(perguntaTitulo: 'addddd le2'),
        Pergunta(perguntaTitulo: 'aaadddddd leve33'),
      ]),
    );
    camadaEvent.add(camadasController.value);
  }

  void removeCamada(int ii) {
    //  print(camadasController.value[camadaSelecinadaController.value].perguntaDaCamada.length);
    camadasController.value.removeAt(ii);
    //    print(camadasController.value[camadaSelecinadaController.value].perguntaDaCamada.length);
    camadaEvent.add(camadasController.value);
  }

  void nomePiramide(String nomeP) {
    piramideController.value.nome = nomeP;
    piramideController.add(piramideController.value);
  }
}
