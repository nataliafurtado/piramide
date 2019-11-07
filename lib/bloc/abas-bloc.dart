import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/camada.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbasBloc extends BlocBase {
  AbasBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static List<Piramide> list = [
    Piramide(nome: '', camadasDaPiramide: [], dataInicio: '')
  ];

  static List<Piramide> listPode = [
    Piramide(nome: '', camadasDaPiramide: [], dataInicio: '')
  ];

  var piramidesController = BehaviorSubject<List<Piramide>>();
  //   var piramidesController = BehaviorSubject<List<Piramide>>.seeded(list);
  Observable<List<Piramide>> get piramidesFluxo => piramidesController.stream;
  Sink<List<Piramide>> get piramidesEvent => piramidesController.sink;

  var piramidesPodeRelatarController = BehaviorSubject<List<Piramide>>();
  Observable<List<Piramide>> get piramidesPodeRelatarFluxo =>
      piramidesPodeRelatarController.stream;
  Sink<List<Piramide>> get piramidesPodeRelatarEvent =>
      piramidesPodeRelatarController.sink;

  Future<bool> carregaPiramidePodeRelatar() async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;

    DocumentSnapshot result =
        await db.collection('usuarios').document(uid).get();
    Usuario user1 = Usuario.fromMap(result.data, result.documentID);
    List<Piramide> l = [];
    for (var i = 0; i < user1.piramidesPodeRelatarId.length; i++) {
      DocumentSnapshot result1 = await db
          .collection('piramides')
          .document(user1.piramidesPodeRelatarId[i])
          .get();
      if (result1.exists) {
        l.add(Piramide.fromMap(result1.data, result1.documentID));
      }
    }

    // final QuerySnapshot result = await db
    //     // .collection('usuarios')
    //     // .document(uid)
    //     .collection('piramides')
    //     .where('usuarioId', isEqualTo: uid)
    //     .getDocuments();
    // final List<DocumentSnapshot> documents = result.documents;
    // List<Piramide> l = [];
    // documents.forEach((data) {
    //   l.add(Piramide.fromMap(data.data, data.documentID));
    // });

    piramidesPodeRelatarEvent.add(l);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emailLogado = prefs.getString('novoUsuario');
    return true;
  }

  void carregaPiramide() async {
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;

    final QuerySnapshot result = await db
        // .collection('usuarios')
        // .document(uid)
        .collection('piramides')
        .where('usuarioId', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    List<Piramide> l = [];
    documents.forEach((data) {
      l.add(Piramide.fromMap(data.data, data.documentID));
    });
    // print(l.length);
    piramidesEvent.add(l);

// for (var ll in l) {
//   print("teste teste teste ");
//   print(ll.nome);
//   print(ll.camadasDaPiramide[0].nome);
// }
  }

  // String teste() {
  //   print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  //   print(piramidesController.value[0].nome);
  //   return piramidesController.value[0].nome;
  // }

  @override
  void dispose() {
    piramidesController.close();
    piramidesPodeRelatarController.close();
    super.dispose();
  }

  void alteraPergunta(int ind, perguntasEnum novoEnum) {}
}
