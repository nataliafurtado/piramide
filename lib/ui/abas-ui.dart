import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/singleton-bloc.dart';
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
SingletonBloc blocSingleton = BlocProvider.getBloc<SingletonBloc>();
class AbaUi extends StatefulWidget {
  final int aba;
  final bool novoUsuario;
  bool mostraPiramideAdm;
  AbaUi({this.aba, this.novoUsuario, this.mostraPiramideAdm});
  static const route = '/home-ui';

  @override
  _AbaUiState createState() => _AbaUiState();
}

class _AbaUiState extends State<AbaUi> {
  int _index1 = 0;
  List<Tab> listTab = new List();
  List<Widget> listWidgets = new List();

  String titulo = '';
  String _tituloApp(int pag) {
    if (widget.mostraPiramideAdm) {
      if (pag == 0) {
        return 'PIRAMIDES ADMINISTRO';
      } else if (pag == 1) {
        return 'PIRAMIDES FAÇO PARTE ';
      } else if (pag == 2) {
        return 'PIRAMIDES';
      }
    } else {
      if (pag == 0) {
        return 'PIRAMIDES FAÇO PARTE ';
      } else if (pag == 1) {
        return 'PIRAMIDES';
      }
    }

    return 'PIRAMIDES';
  }

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 1)).then((d) {

    // });
   // singletonBloc = SingletonBloc();
    titulo = _tituloApp(widget.aba);
    moverAnimeIcons(widget.aba);
    carregaTabs();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4315692542852907~8105772849");

    startBanner();
    displayBanner();
    super.initState();
  }

  void carregaTabs() {
    if (widget.mostraPiramideAdm) {
      listTab.add(Tab(child: iconePiramideAdm()));
    }
    listTab.add(Tab(child: iconePiramideFazParte()));
    listTab.add(Tab(child: iconePiramides()));
    if (widget.mostraPiramideAdm) {
      listWidgets.add(PiramideAdministro());
    }

    listWidgets.add(PiramidePodeRelatar(
      novoUsuario: widget.novoUsuario,
    ));
    listWidgets.add(Piramides());
  }

  @override
  void dispose() {
    myBanner?.dispose();
    //myInterstitial?.dispose();
    super.dispose();
  }

  void moverAnimeIcons(int index) {
    print(index);
    if (widget.mostraPiramideAdm) {
      if (index == 0) {
        controllPirAdmAnime.play('go');
      } else if (index == 1) {
        controllPirFazParteAnime.play('go');
      } else {
        controllPiramidesAnime.play('go');
      }
    } else {
      if (index == 0) {
        controllPirFazParteAnime.play('go');
      } else if (index == 1) {
        controllPiramidesAnime.play('go');
      }
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
          print('ddddddddddddddddddddddddddddddddeweeeeeeeeeeeeeeee');
          blocSingleton.bannerEvent.add(0);
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
    keywords: <String>['industry', 'safety'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[],
  );

  BannerAd myBanner;

  final FlareControls controllPirAdmAnime = FlareControls();
  final FlareControls controllPirFazParteAnime = FlareControls();
  final FlareControls controllPiramidesAnime = FlareControls();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.aba == null ? 0 : widget.aba,
      length: widget.mostraPiramideAdm ? 3 : 2,
      child: StreamBuilder(
                stream: blocSingleton.bannerFluxo,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.only(bottom: snapshot.data??0),
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
                  tabs: listTab,
                ),
              ),
              body: TabBarView(
                children: listWidgets,
              ),
            ),
          );
        }
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
