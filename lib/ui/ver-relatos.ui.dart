import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/ver-relatos-bloc.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/ui/novo-relato-ui.dart';
import 'package:comportamentocoletivo/ui/relato-ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

VerRelatosBloc verRealatoBloc = BlocProvider.getBloc<VerRelatosBloc>();

class VerRelatos extends StatefulWidget {
  final Piramide piramide;
  final int camada;
  final Periodo periodo;
  final Informacoes informacoes;
  VerRelatos({this.piramide, this.camada, this.periodo, this.informacoes});
  static const route = '/ver-relatos';
  @override
  _VerRelatosState createState() => _VerRelatosState();
}

class _VerRelatosState extends State<VerRelatos> {
  bool mostrausuario = false;

  @override
  void initState() {
    verRealatoBloc = VerRelatosBloc();
    // print(widget.periodo.geral);
    verRealatoBloc.carregaUsuarioId();
    verRealatoBloc.carregaRelatosVazio(
        widget.piramide.piramideId, widget.camada, widget.periodo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VER RELATOS'),
        ),
        body: StreamBuilder(
          stream: verRealatoBloc.txFluxo,
          builder: (ctx, snaptx) {
            return StreamBuilder(
              stream: verRealatoBloc.usuariosFluxo,
              builder: (ctx, snapshotUsuarios) {
                return StreamBuilder(
                    stream: verRealatoBloc.realatoFluxo,
                    builder: (context, snapshotRelatos) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              // RaisedButton(
                              //   onPressed: () {
                              //     print('to sringo');
                              //     for (var i = 0; i < snapshotRelatos.data.length; i++) {
                              //       print(snapshotRelatos.data[i].nome);
                              //     }
                              //   },
                              //   child: Text('snapshotRelatos.data[0].nome'),
                              // ),

                              Container(
                                height: 80,
                                color: Colors.blue.shade50,
                                child: Center(
                                  child: TextField(
                                    controller:
                                        verRealatoBloc.txController.value,
                                    onChanged: (tx) {
                                      setState(() {
                                        mostrausuario = true;
                                      });
                                      if (tx.isNotEmpty && tx.length > 2) {
                                        // verRealatoBloc.txEvent.add(tx);
                                        // verRealatoBloc.carregaRelatos(
                                        //     tx,
                                        //     widget.piramide.piramideId,
                                        //     widget.camada,
                                        //     widget.periodo);
                                        verRealatoBloc.carregaUmUsuariDeRelatos(
                                          tx,
                                          widget.piramide.piramideId,
                                          widget.camada,
                                        );
                                      } else {
                                        verRealatoBloc.relatoEvent.add([]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(Icons.change_history),
                                        hintText: 'Informe um nome'),
                                  ),
                                ),
                              ),

                              // Container(
                              //   height: 20,
                              // ),
                              //  Container(
                              //   height: 20,
                              //  // color: Colors.blue.shade200,
                              //   child: Align(
                              //   alignment: Alignment(-1,0),
                              //     child:snapshotRelatos.data==null ?Text(''):Text('ECONTRADO ${snapshotRelatos.data.length} RELATOS')),
                              // ),

                              Visibility(
                                  visible: mostrausuario,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      // color: Colors.blue.shade100,
                                      child: ListView.builder(
                                        itemCount: snapshotUsuarios.data == null
                                            ? 0
                                            : snapshotUsuarios.data.length,
                                        itemBuilder: (ctx, indexUsuarios) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                mostrausuario = false;
                                              });
                                              verRealatoBloc
                                                      .txController.value.text =
                                                  snapshotUsuarios
                                                      .data[indexUsuarios].nome;
                                              verRealatoBloc.txEvent.add(
                                                  verRealatoBloc
                                                      .txController.value);

                                              verRealatoBloc.carregaRelatos(
                                                  snapshotUsuarios
                                                      .data[indexUsuarios]
                                                      .usuarioId,
                                                  widget.piramide.piramideId,
                                                  widget.camada,
                                                  widget.periodo);
                                            },
                                            splashColor: Colors.orange,
                                            child: Card(
                                              elevation: 7,
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Text(snapshotUsuarios
                                                    .data[indexUsuarios].nome),
                                              ),
                                            ),
                                          );
                                        },
                                      ))),

                              Visibility(
                                visible: !mostrausuario,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  //color: Colors.blue,
                                  child: ListView.builder(
                                    itemCount: snapshotRelatos.data == null
                                        ? 0
                                        : (snapshotRelatos.data.length > 4
                                            ? snapshotRelatos.data.length + 1
                                            : snapshotRelatos.data.length),
                                    itemBuilder: (ctx, index) {
                                      return index ==
                                              snapshotRelatos.data.length
                                          ? Card(
                                              color: Colors.white,
                                              elevation: 10,
                                              // height: 40,
                                              child: Padding(
                                                  padding: EdgeInsets.all(0.0),
                                                  child: Center(
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.add_circle),
                                                      onPressed: () {
                                                        verRealatoBloc
                                                            .carregaMaisRelatos(
                                                                widget.piramide
                                                                    .piramideId,
                                                                widget.camada,
                                                                widget.periodo);
                                                      },
                                                    ),
                                                  )),
                                            )
                                          : InkWell(
                                              splashColor: Colors.orange,
                                              onTap: () {
                                                // if (snapshotRelatos.data[index]
                                                //         .usuarioRelatouId ==
                                                //     verRealatoBloc
                                                //         .usuarioOnlineId) {
                                                //   Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (context) =>
                                                //               NovoRelato(
                                                //            relato:snapshotRelatos.data[index],
                                                //               piramide: widget.piramide,
                                                //               camadaIndex:widget.camada,
                                                //               periodo: widget.periodo,
                                                //               informacoes: widget.informacoes,
                                                //               usuarioLogadoId:verRealatoBloc.usuarioOnlineId
                                                //               )));
                                                // } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => RelatoUi(
                                                              relato:snapshotRelatos.data[index],
                                                              piramide: widget.piramide,
                                                              camada:widget.camada,
                                                              periodo: widget.periodo,
                                                              informacoes: widget.informacoes,
                                                              usuarioLogadoId:verRealatoBloc.usuarioOnlineId)));
                                               // }
                                              },
                                              child: Card(
                                                color: Colors.blue.shade50,
                                                elevation: 5,
                                                // height: 40,
                                                child: Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(snapshotRelatos
                                                          .data[index]
                                                          .usarioNome),
                                                      Text(_formataData(
                                                          snapshotRelatos
                                                              .data[index]
                                                              .datacriacao))
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          },
        ));
  }

  Widget _row(Relato item) {
    return Row(
      children: <Widget>[
        Text(
          item.usarioNome,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }

  // void _carregaRelatos(String text) {
  //   //&& text.length>1
  //   if (text != null && text.isNotEmpty) {
  //     print("frjujuj");
  //     // verRelatosBloc.carregaRelatos(text);
  //     setState(() {});
  //   }
  //   // print("bunca");
  // }
  String _formataData(String data) {
    if (data == null) {
      return '   ABERTA   ';
    }
    DateTime t = DateTime.parse(data);
    String formattedDate = DateFormat('dd/MM/yyyy : HH:mm:ss').format(t);
    //  print('11111');
    //  print(formattedDate);
    return formattedDate;
  }
}
