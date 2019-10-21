import 'package:comportamentocoletivo/main.dart';
import 'package:comportamentocoletivo/ui/ajuda/ajuda-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-pode-relatar-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-administro-ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OrderOptions { comofunciona, logout }
final FirebaseAuth _auth = FirebaseAuth.instance;

class AbaUi extends StatefulWidget {
  final int aba;
  AbaUi({this.aba});
  static const route = '/home-ui';

  @override
  _AbaUiState createState() => _AbaUiState();
}

class _AbaUiState extends State<AbaUi> {
  int _index1 = 0;

  String titulo = 'PIRAMIDES ADMINISTRO';
  String _tituloApp(int pag) {
    if (pag == 0) {
      return 'PIRAMIDES ADMINISTRO';
    } else if (pag == 1) {
      return 'PIRAMIDES FAÇO PARTE ';
    } else if (pag == 2) {
      return 'PIRAMIDES';
    }

    return 'PIRAMIDES';
  }

  void _orderList(OrderOptions result) async {
    switch (result) {
      case OrderOptions.comofunciona:
        Navigator.pushNamed(context, AjudaUi.route);
        break;
      case OrderOptions.logout:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');
        GoogleSignIn _googleSignIn = GoogleSignIn();
        await _googleSignIn.signOut();
        _auth.signOut().then((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });

        //  Navigator.popUntil(context, ModalRoute.withName("/"));

        // Navigator.pushReplacement(context,
        //                   MaterialPageRoute(builder: (context) => LoginScreen3()));

        //                        Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (ctx) => LoginScreen3()),
        //   ModalRoute.withName('/'),
        // );

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.aba == null ? 0 : widget.aba,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Como funciona ?"),
                  value: OrderOptions.comofunciona,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Sair"),
                  value: OrderOptions.logout,
                ),
              ],
              onSelected: _orderList,
            ),
          ],
          title: Center(
            child: Text(titulo),
          ),
          bottom: TabBar(
            onTap: (indexx) {
              setState(() {
                titulo = '_tituloApp(indexx)';
              });
            },
            tabs: <Widget>[
              Tab(icon: Icon(Icons.change_history)),
              Tab(icon: Icon(Icons.details)),
              Tab(icon: Icon(Icons.filter_hdr)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PiramideAdministro(),
            PiramidePodeRelatar(),
            Piramides(),
          ],
        ),
      ),
    );
  }
}
