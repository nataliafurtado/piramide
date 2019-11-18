import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/model/carteira.dart';
import 'package:comportamentocoletivo/model/creditos.dart';
import 'package:comportamentocoletivo/model/usuario.dart';

//import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ComprarCreditoBloc extends BlocBase {
  ComprarCreditoBloc();

  // final cpiController = BehaviorSubject<bool>.seeded(false);
  // Observable<bool> get cpiFluxo => cpiController.stream;
  // Sink<bool> get cpiEvent => cpiController.sink;

  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var listController = BehaviorSubject<List<ProductDetails>>();
  Observable<List<ProductDetails>> get listFluxo => listController.stream;
  Sink<List<ProductDetails>> get listEvent => listController.sink;

  var carteiraController = BehaviorSubject<Carteira>.seeded(Carteira(saldo: 0));
  Observable<Carteira> get carteiraFluxo => carteiraController.stream;
  Sink<Carteira> get carteiraEvent => carteiraController.sink;

  // String teste() {
  //   print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  //   print(piramidesController.value[0].nome);
  //   return piramidesController.value[0].nome;
  // }

  @override
  void dispose() {
    listController.close();
    carteiraController.close();
    super.dispose();
  }

  void teste() async {
    print('111111');
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    final QuerySnapshot result = await db
        .collection('carteiras')
        .where('usuarioId', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    carteiraEvent
        .add(Carteira.fromMap(documents[0].data, documents[0].documentID));


    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print(available);
    if (available) {
      // The store cannot be reached or accessed. Update the UI accordingly.

      const Set<String> _kIds = {'credito29.99', 'credito99.99'};
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (!response.notFoundIDs.isEmpty) {
        
        
      }
      List<ProductDetails> products = response.productDetails;

      listEvent.add(products);

      for (var i = 0; i < products.length; i++) {
        print(products[i].title);
      }
    }
  }

  void listarJaCOmprados() async {
    print('dddddd');
    final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();
    print(response.pastPurchases.length);
    if (response.error != null) {
      // Handle the error.
    }
    for (PurchaseDetails purchase in response.pastPurchases) {
//    // _verifyPurchase(purchase);  // Verify the purchase following the best practices for each storefront.
//    // _deliverPurchase(purchase); // Deliver the purchase to the user in your app.
//     if (Platform.isIOS) {
//         // Mark that you've delivered the purchase. Only the App Store requires
//         // this final confirmation.
//         InAppPurchaseConnection.instance.completePurchase(purchase);
//     }
      print(purchase.toString());
    }
  }

  void comprar(int index) async {
    //   final ProductDetails productDetails = ... // Saved earlier from queryPastPurchases().
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid;
    // final PurchaseParam purchaseParam =
    //     PurchaseParam(productDetails: listController.value[index]);
    // bool deucerto = await InAppPurchaseConnection.instance
    //     .buyConsumable(purchaseParam: purchaseParam);

    // InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // print(deucerto.toString() +
    //     '  deucerto  deucertodeucerto deucertodeucerto deucertodeucerto');

    Carteira c = carteiraController.value;

    DocumentReference tranDoc = await db.collection('creditos').document();
    db.collection('creditos').document(tranDoc.documentID).setData(Credito(
            usuarioId: c.usuarioId,
            data: DateTime.now().toIso8601String(),
            idLoja: listController.value[index].id,
            sku: listController.value[index].skuDetail.sku,
            valor: valor(listController.value[index].id))
        .toMap());
//comeca atualza usuarios publicidae
    DocumentSnapshot result =
        await db.collection('usuarios').document(uid).get();
    Usuario user1 = Usuario.fromMap(result.data, result.documentID);
    List<Usuario> l = [];
    for (var i = 0; i < user1.piramidesAdmnistra.length; i++) {
      final QuerySnapshot result = await db
          .collection('usuarios')
          .where('piramidesPodeRelatarId',
              arrayContains: user1.piramidesAdmnistra[i])
          .getDocuments();
      List<DocumentSnapshot> documents = result.documents;
      documents.forEach((data) {
        l.add(Usuario.fromMap(data.data, data.documentID));
      });
    }
    var batch = db.batch();
    for (var i = 0; i < l.length; i++) {
      batch.updateData(db.collection('usuarios').document(l[i].usuarioId),
          {'publicidade': false});
    }
    batch.commit();

    c.saldo = c.saldo + valor(listController.value[index].id);
    await db
        .collection('carteiras')
        .document(c.carteiraId)
        .updateData(c.toMap());

    carteiraEvent.add(c);
    print('checou finalo ');
    // DocumentSnapshot snapNovo =
    //       await db.collection('carteiras').where(field).get();
    //  Usuario user1 = Usuario.fromMap(snapNovo.data, snapNovo.documentID);
  }

  double valor(String id) {
    if (id == 'credito29.99') {
      return 29.99;
    } else if (id == 'credito29.99') {
      return 99.99;
    } else if (id == 'credito00.99') {
      return 00.99;
    }
  }
}
