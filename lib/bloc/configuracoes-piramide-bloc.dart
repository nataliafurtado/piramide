import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/pedido.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ConfiguracoesPiramideBloc extends BlocBase {
  ConfiguracoesPiramideBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // var piramidesPodeRelatarController =
  //     BehaviorSubject<List<Piramide>>();
  // Observable<List<Piramide>> get piramidesPodeRelatarFluxo =>
  //     piramidesPodeRelatarController.stream;
  // Sink<List<Piramide>> get piramidesPodeRelatarEvent =>
  //     piramidesPodeRelatarController.sink;

  // void carregaPiramidePodeRelatar() async {
  //   final FirebaseUser user = await _auth.currentUser();
  //   final String uid = user.uid;

  //   DocumentSnapshot result =
  //       await db.collection('usuarios').document(uid).get();
  //   Usuario user1 = Usuario.fromMap(result.data,result.documentID);
  //   List<Piramide> l = [];
  //   for (var i = 0; i < user1.piramidesPodeRelatarId.length; i++) {
  //     DocumentSnapshot result1 = await db
  //         .collection('piramides')
  //         .document(user1.piramidesPodeRelatarId[i])
  //         .get();
  //     l.add(Piramide.fromMap(result1.data, result1.documentID));
  //   }

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

  //    piramidesPodeRelatarEvent.add(l);
  // }

//   void carregaPiramide() async {
//     final FirebaseUser user = await _auth.currentUser();
//     final String uid = user.uid;
//     final QuerySnapshot result = await db
//         // .collection('usuarios')
//         // .document(uid)
//         .collection('piramides')
//         .where('usuarioId', isEqualTo: uid)
//         .getDocuments();
//     final List<DocumentSnapshot> documents = result.documents;
//     List<Piramide> l = [];
//     documents.forEach((data) {
//       l.add(Piramide.fromMap(data.data, data.documentID));
//     });
//     // print(l.length);
//     piramidesEvent.add(l);

// // for (var ll in l) {
// //   print("teste teste teste ");
// //   print(ll.nome);
// //   print(ll.camadasDaPiramide[0].nome);
// // }
//   }

  // String teste() {
  //   print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  //   print(piramidesController.value[0].nome);
  //   return piramidesController.value[0].nome;
  // }

  @override
  void dispose() {
    // piramidesController.close();
    // piramidesPodeRelatarController.close();
    super.dispose();
  }

  void salvarPiramide(Piramide piramide) async {
    await db
        .collection('piramides')
        .document(piramide.piramideId)
        .updateData(piramide.toMap());
    print(piramide.piramideId);
  }

  void excluirPiramide(String piramideId) async {
    final QuerySnapshot result = await db
        .collection('relatos')
        .where('piramideId', isEqualTo: piramideId)
        .getDocuments();

    List<DocumentSnapshot> documents = result.documents;

    List<Relato> l = [];
    documents.forEach((data) {
      l.add(Relato.fromMap(data.data, data.documentID));
    });

    for (var i = 0; i < l.length; i++) {
      await db.collection('relatos').document(l[i].relatoId).delete();
    }

    final QuerySnapshot result1 = await db
        .collection('informacoes')
        .where('piramideId', isEqualTo: piramideId)
        .getDocuments();
    List<DocumentSnapshot> documents1 = result1.documents;
    List<Informacoes> ll = [];
    documents1.forEach((data) {
      ll.add(Informacoes.fromMap(data.data, data.documentID));
    });
    for (var i = 0; i < ll.length; i++) {
         await db.collection('informacoes').document(ll[i].informacoesId).delete();
    }


    final QuerySnapshot result2 = await db
        .collection('informacoes')
        .where('piramideId', isEqualTo: piramideId)
        .getDocuments();
    List<DocumentSnapshot> documents2 = result2.documents;
    List<Pedido> lll = [];
    documents2.forEach((data) {
      lll.add(Pedido.fromMap(data.data, data.documentID));
    });
    for (var i = 0; i < lll.length; i++) {
         await db.collection('pedidos').document(lll[i].pedidoId).delete();
    }

    await db.collection('piramides').document(piramideId).delete();
  }
}
