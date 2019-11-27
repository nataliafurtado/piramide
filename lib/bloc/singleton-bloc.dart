import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class SingletonBloc extends BlocBase {
  SingletonBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // static List<Piramide> list = [
  //   Piramide(nome: '', camadasDaPiramide: [], dataInicio: '')
  // ];

  // static List<Piramide> listPode = [
  //   Piramide(nome: '', camadasDaPiramide: [], dataInicio: '')
  // ];

  var bannerController = BehaviorSubject<double>.seeded(48);
  Observable<double> get bannerFluxo => bannerController.stream;
  Sink<double> get bannerEvent => bannerController.sink;

  // var piramidesPodeRelatarController = BehaviorSubject<List<Piramide>>();
  // Observable<List<Piramide>> get piramidesPodeRelatarFluxo =>
  //     piramidesPodeRelatarController.stream;
  // Sink<List<Piramide>> get piramidesPodeRelatarEvent =>
  //     piramidesPodeRelatarController.sink;

  // Future<bool> carregaPiramidePodeRelatar() async {
  //   final FirebaseUser user = await _auth.currentUser();
  //   final String uid = user.uid;

  //   DocumentSnapshot result =
  //       await db.collection('usuarios').document(uid).get();
  //   Usuario user1 = Usuario.fromMap(result.data, result.documentID);
  //   List<Piramide> l = [];
  //   for (var i = 0; i < user1.piramidesPodeRelatarId.length; i++) {
  //     DocumentSnapshot result1 = await db
  //         .collection('piramides')
  //         .document(user1.piramidesPodeRelatarId[i])
  //         .get();
  //     if (result1.exists) {
  //       l.add(Piramide.fromMap(result1.data, result1.documentID));
  //     }
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

  //   piramidesPodeRelatarEvent.add(l);

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var emailLogado = prefs.getString('novoUsuario');
  //   return true;
  // }

  

  // @override
  // void dispose() {
  //    bannerController.close();
  //   // piramidesPodeRelatarController.close();
  //   super.dispose();
  // }


}
