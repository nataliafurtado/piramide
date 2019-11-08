import 'package:comportamentocoletivo/main.dart';
import 'package:comportamentocoletivo/ui/ajuda/ajuda-ui.dart';
import 'package:comportamentocoletivo/ui/comprar-credito-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-pode-relatar-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-administro-ui.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OrderOptions { comofunciona, logout, comprar }
final FirebaseAuth _auth = FirebaseAuth.instance;

class AbaUi extends StatefulWidget {
  final int aba;
  final bool novoUsuario;
  AbaUi({this.aba, this.novoUsuario});
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

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 1)).then((d) {

    // });
    print('init');
    moverAnimeIcons(widget.aba);

      FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4315692542852907~8105772849");

    startBanner();
    displayBanner();
    super.initState();
  }
 @override
  void dispose() {
    myBanner?.dispose();
    //myInterstitial?.dispose();
    super.dispose();
  }

  void moverAnimeIcons(int index) {
    print(index);
    if (index == 0) {
      controllPirAdmAnime.play('go');
    } else if (index == 1) {
      controllPirFazParteAnime.play('go');
    } else {
      controllPiramidesAnime.play('go');
    }
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
      case OrderOptions.comprar:
   Navigator.pushNamed(context, ComprarCreditoUi.route);


        break;
    }
  }
void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }
void startBanner() {
    myBanner = BannerAd(
      //
      //4315692542852907/4611033356
      adUnitId:
      // BannerAd.testAdUnitId,
      'ca-app-pub-4315692542852907/4611033356',
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
         setState(() {
            bannerAjuste=0;
         });
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //  keywords: <String>['industry', 'safety'],
  //  contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[],
);

BannerAd myBanner;
double bannerAjuste=50;
  final FlareControls controllPirAdmAnime = FlareControls();
  final FlareControls controllPirFazParteAnime = FlareControls();
  final FlareControls controllPiramidesAnime = FlareControls();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.aba == null ? 0 : widget.aba,
      length: 3,
      child: Padding(
        padding: EdgeInsets.only(bottom: bannerAjuste),
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
                    child: Text("Comprar Créditos"),
                    value: OrderOptions.comprar,
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
                  titulo = _tituloApp(indexx);
                  moverAnimeIcons(indexx);
                });
                print(indexx.toString() + 'indez');
              },
              tabs: <Widget>[
                Tab(
                  child: iconePiramideAdm(),
                ),
                Tab(
                  child: iconePiramideFazParte(),
                ),
                Tab(
                  child: iconePiramides(),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PiramideAdministro(),
              PiramidePodeRelatar(
                novoUsuario: widget.novoUsuario,
              ),
              Piramides(),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconePiramideAdm() {
    // print(pirAdmAnime.toString());
    return FlareActor(
      'assets/piramide.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'idle',
      controller: controllPirAdmAnime,
      color: Colors.white70,
    );
  }

  Widget iconePiramideFazParte() {
    // print(pirAdmAnime.toString());
    return FlareActor(
      'assets/piramide2.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'idle',
      controller: controllPirFazParteAnime,
      color: Colors.white70,
    );
  }

  Widget iconePiramides() {
    // print(pirAdmAnime.toString());
    return FlareActor(
      'assets/piramide3.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'idle',
      controller: controllPiramidesAnime,
      color: Colors.white70,
    );
  }
}
