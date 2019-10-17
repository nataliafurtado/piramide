import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/configuracoes-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:flutter/material.dart';

ConfiguracoesPiramideBloc blocConfiguracoesPiramide =
    BlocProvider.getBloc<ConfiguracoesPiramideBloc>();

class ConfiguracoesPiramide extends StatefulWidget {
  final Piramide piramide;
  final bool mostrarSalvar;

  ConfiguracoesPiramide({this.piramide, this.mostrarSalvar});
  static const route = '/configuracoes-piramide';

  @override
  _ConfiguracoesPiramideState createState() => _ConfiguracoesPiramideState();
}

class _ConfiguracoesPiramideState extends State<ConfiguracoesPiramide> {
  @override
  void dispose() {
    blocConfiguracoesPiramide.dispose();
    super.dispose();
  }

  @override
  void initState() {
    blocConfiguracoesPiramide = ConfiguracoesPiramideBloc();
    super.initState();
  }

  final snackBar = SnackBar(content: Text('Salvo'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONFIGURAÇÕES'),
        actions: <Widget>[
          Visibility(
            visible:
                widget.mostrarSalvar == null ? false : widget.mostrarSalvar,
            child: Builder(
              builder: (ctx) {
                return FlatButton(
                  onPressed: () async {
                    blocConfiguracoesPiramide.salvarPiramide(widget.piramide);
                    Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('SALVO'),
                                    ),
                                  );
                  },
                  child: Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('PÚBLICA'),
                Checkbox(
                  value: widget.piramide.publica,
                  onChanged: (valor) {
                    print(valor);
                    setState(() {
                      widget.piramide.publica = valor;
                    });
                  },
                ),
              ],
            ),
            // Container(
            //   height: 30,
            //   child: Center(
            //     child: Text('Lista Usuários'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
