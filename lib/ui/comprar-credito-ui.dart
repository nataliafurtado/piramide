import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/comprar-credito-bloc.dart';
import 'package:comportamentocoletivo/ui/precos-ui.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

ComprarCreditoBloc blocComprarCerdito =
    BlocProvider.getBloc<ComprarCreditoBloc>();

class ComprarCreditoUi extends StatefulWidget {
  static const route = '/comprar-creditos';
  @override
  _ComprarCreditoUiState createState() => _ComprarCreditoUiState();
}

class _ComprarCreditoUiState extends State<ComprarCreditoUi> {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  @override
  void initState() {
    blocComprarCerdito = ComprarCreditoBloc();
    blocComprarCerdito.teste();
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    super.initState();
  }

    void _handlePurchaseUpdates(List<PurchaseDetails> purchase) {
    for (var i = 0; i < purchase.length; i++) {

      blocComprarCerdito.somarCompraNoSitema(purchase[i]);
      // print('id  ' + purchase[i].productID);
      // print('orderid  ' + purchase[i].billingClientPurchase.orderId);
      // print('status  ' + purchase[i].status.toString());
      // print('jsinn  ' + purchase[i].billingClientPurchase.originalJson);
    }
  }

  @override
  void dispose() {
    blocComprarCerdito.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COMPRAR CRÉDITO'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, PrecosUi.route);
              //  blocComprarCerdito.listarJaCOmprados();
            },
            child: Text(
              'PREÇOS',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        //  mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder(
            stream: blocComprarCerdito.carteiraFluxo,
            builder: (ctx, snap1) {
              return Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(width: 1, color: Colors.blue),
                    borderRadius:
                        // BorderRadius.all(Radius.circular(10))
                        BorderRadius.all(Radius.circular(10))),
                //    ),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Seu saldo'),
                    Container(
                      width: 15,
                    ),
                    Text(
                        'R\$ ${blocComprarCerdito.carteiraController.value.saldo.toStringAsFixed(2)}'),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: blocComprarCerdito.listFluxo,
              builder: (ctx, snap) {
                if (snap.data == null || snap.data.length == 0) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (ctx, indexList) {
                      return Container(
                        width: 200,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey.shade50,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.payment,
                                  size: 70,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                    snap.data[indexList].title
                                        .toString()
                                        .substring(0, 20),
                                    style: TextStyle(color: Colors.blue)),
                                subtitle: Text(snap.data[indexList].price,
                                    style: TextStyle(color: Colors.black)),
                              ),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: const Text('COMPRAR',
                                          style: TextStyle(color: Colors.pink)),
                                      onPressed: () {
                                        blocComprarCerdito.comprar(indexList);

                                        //blocComprarCerdito.existente(indexList);
                                      },
                                    ),
                                    // FlatButton(
                                    //   child: const Text('Delete', style: TextStyle(color: Colors.pink)),
                                    //   onPressed: () {},
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            child: Text('Pague pelo GOOGLE PLAY ou APP STORE'),
          ),
        ],
      ),
    );
  }


}
