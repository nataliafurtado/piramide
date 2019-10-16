import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/abas-bloc.dart';
import 'package:comportamentocoletivo/bloc/aceitar-usuario-bloc.dart';
import 'package:comportamentocoletivo/bloc/informacoes-bloc.dart';

import 'package:comportamentocoletivo/bloc/nova-piramide-bloc.dart';
import 'package:comportamentocoletivo/bloc/novo-relato-bloc.dart';
import 'package:comportamentocoletivo/bloc/procurar-piramide-bloc.dart';
import 'package:comportamentocoletivo/bloc/ver-relatos-bloc.dart';
import 'package:comportamentocoletivo/login/login-bloc.dart';
import 'package:comportamentocoletivo/login/login.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:comportamentocoletivo/ui/aceitar-usuarios/aceitar-usuarios-ui.dart';
import 'package:comportamentocoletivo/ui/ajuda/ajuda-ui.dart';

import 'package:comportamentocoletivo/ui/configuracoes-piramide.dart';
import 'package:comportamentocoletivo/ui/informacoes-ui.dart';
import 'package:comportamentocoletivo/ui/nova-piramide-ui.dart';
import 'package:comportamentocoletivo/ui/novo-relato-ui.dart';
import 'package:comportamentocoletivo/ui/procurar-piramide-ui.dart';
import 'package:comportamentocoletivo/ui/relato-ui.dart';
import 'package:comportamentocoletivo/ui/ver-relatos.ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.yellowAccent.shade700),
      home: Scaffold(
        body: Container(
            child: BlocProvider(
          blocs: [
            Bloc((i) => NovaPiramideBLoc()),
            Bloc((i) => AbasBloc()),
            Bloc((i) => NovoRelatoBloc()),
            Bloc((i) => LoginBloc(context)),
            Bloc((i) => ProcurarPiramideBloc()),
            Bloc((i) => AceitarUsuarioBloc()),
            Bloc((i) => InformacoesBloc()),
            Bloc((i) => VerRelatosBloc()),
          ],
          child: LoginScreen3(),
          //   child: AbaUi(),
        )),
      ),
      routes: {
        // '/': (context) => AbaUi(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        NovaPiramide.route: (context) => NovaPiramide(),
        AbaUi.route: (context) => AbaUi(),
        ConfiguracoesPiramide.route: (context) => ConfiguracoesPiramide(),
        NovoRelato.route: (context) => NovoRelato(),
        ProcurarPiramide.route: (context) => ProcurarPiramide(),
        InformacoesUi.route: (context) => InformacoesUi(),
        AceitarUsuario.route: (context) => AceitarUsuario(),
        VerRelatos.route: (context) => VerRelatos(),
        RelatoUi.route: (context) => RelatoUi(),
        AjudaUi.route: (context) => AjudaUi(),
      },
    );
  }
}