import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/configuracoes-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:flutter/material.dart';

ConfiguracoesPiramideBloc blocConfiguracoesPiramide =
    BlocProvider.getBloc<ConfiguracoesPiramideBloc>();

class ConfiguracoesPiramide extends StatefulWidget {
  final Piramide piramide;
  final bool salvarAutomatico;

  ConfiguracoesPiramide({this.piramide, this.salvarAutomatico});
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
            visible: widget.salvarAutomatico == null
                ? false
                : widget.salvarAutomatico,
            child: Builder(
              builder: (ctx) {
                return FlatButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('ATENÇÃO'),
                            content: Text(
                                'Tem certeza que deseja excluir permanentemente essa piramides e todos os seus relatos?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {

 showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('ATENÇÃO'),
                            content: Text(
                                'Depois de excluída não poderá mais ser recuperada?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  await blocConfiguracoesPiramide
                                      .excluirPiramide(
                                          widget.piramide.piramideId);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AbaUi.route,
                                      ModalRoute.withName(AbaUi.route));
                                  // Navigator.of(context).pop();
                                  //  Navigator.of(context).pop();
                                },
                                child: Text('EXCLUIR'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                   Navigator.of(context).pop();
                                },
                                child: Text('CANCELAR'),
                              ),
                            ],
                          );
                        });


                                },
                                child: Text('EXCLUIR'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('CANCELAR'),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    'EXCLUIR',
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
                    setState(() {
                      widget.piramide.publica = valor;
                    });
                    if (widget.salvarAutomatico != null &&
                        widget.salvarAutomatico == true) {
                      print('salvo automatico');
                      blocConfiguracoesPiramide.salvarPiramide(widget.piramide);
                    }
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
