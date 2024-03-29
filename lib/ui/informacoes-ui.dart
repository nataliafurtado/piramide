import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/bloc/informacoes-bloc.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:comportamentocoletivo/ui/ver-relatos.ui.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

InformacoesBloc infoBloc = BlocProvider.getBloc<InformacoesBloc>();

class InformacoesUi extends StatefulWidget {
  final Piramide piramide;
  final bool usuarioAdm;
  final bool podeDeixarSeguir;
  InformacoesUi({this.piramide, this.usuarioAdm, this.podeDeixarSeguir});
  static const route = '/informacoes';
  @override
  _InformacoesUiState createState() => _InformacoesUiState();
}

class _InformacoesUiState extends State<InformacoesUi> {
  /// bool pronta = false;
  bool podeSalvar = false;

  bool mostrarCircularProgress = false;
  @override
  void initState() {
    infoBloc = InformacoesBloc();
    infoBloc.carregaInfo(widget.piramide);

    // TODO: implement initState
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  // setState(() {
  //     pronta=true;
  //   });
  //   super.didChangeDependencies();
  // }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: blocSingleton.bannerFluxo,
      builder: (context, snapshotBanner) {
        return Padding(
        padding: EdgeInsets.only(bottom: snapshotBanner.data??0),
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                Visibility(
                  visible: podeSalvar,
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        mostrarCircularProgress = true;
                      });
                      await infoBloc.salvar(widget.piramide);

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.podeDeixarSeguir,
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        mostrarCircularProgress = true;
                      });
                      await infoBloc.deixarDeSeguirPiramide(widget.piramide);
                    //  Future.delayed(Duration(seconds: 2));
                     // Navigator.of(context).pop();

                     SharedPreferences prefs = await SharedPreferences.getInstance();

Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          AbaUi(aba: 1,mostraPiramideAdm: prefs.getBool('mostraPiramideAdm'),)), (Route<dynamic> route) => false);

          
                        //  Navigator.pushNamedAndRemoveUntil(
                        //                     context,
                        //                     AbaUi.route,
                        //                     ModalRoute.withName(AbaUi.route));
                    },
                    child: Text(
                      'Deixar de Seguir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
              title: Text(widget.piramide.nome),
            ),
            body: mostrarCircularProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: infoBloc.informacoesFluxo,
                    builder: (ctx, snapshot) {
                      return infoBloc.informacoesController.value != null
                          ? ListView.builder(
                              itemCount: widget.usuarioAdm == true
                                  ? infoBloc.informacoesController.value.periodos
                                          .length +
                                      1
                                  : infoBloc
                                      .informacoesController.value.periodos.length,
                              itemBuilder: (ctx, periIndex) {
                                if (periIndex ==
                                    infoBloc.informacoesController.value.periodos
                                        .length) {
                                  return _addPeriodo();
                                } else if (infoBloc.informacoesController.value
                                    .periodos[periIndex].geral) {
                                  return _piramideCardGeral(periIndex);
                                } else {
                                  return _piramideCard(periIndex);
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
          ),
        );
      }
    );
  }

  Widget _addPeriodo() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('NOVO PERÍODO'),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              setState(() {
                podeSalvar = true;
              });
              infoBloc.novoPeriodo(widget.piramide);
            },
          )
        ],
      ),

      // Center(child: IconButton(icon: Icon(Icons.add_circle),onPressed: (){},),),
    );
  }

  Widget _piramideCardGeral(int periIndex) {
    return Card(
      elevation: 10,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.blue, width: 2)),
      child: Container(
        //height: 350,
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              //   color: Colors.grey,
              height: 40,
              child: Align(
                alignment: Alignment(0, 0),
                child: Text(
                  'TOTAL DE RELATOS ( ${infoBloc.informacoesController.value.periodos[0].totalTodasAsCamadas} ) ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue.shade900),
                ),
              ),
            ),
            Container(
              //tamaho da card
              // color: Colors.cyanAccent,
              height: MediaQuery.of(context).size.width *
                  0.14 *
                  widget.piramide.camadasDaPiramide.length,
              // abasBloc
              //     .piramidesController.value[index].camadasDaPiramide.length,
              //width: 300,
              alignment: Alignment.center,

              child: Container(
                //tamanho conteiner da piremide
                //   color: Colors.grey,
                height: MediaQuery.of(context).size.width *
                    0.12 *
                    widget.piramide.camadasDaPiramide.length,
                // abasBloc
                //     .piramidesController.value[index].camadasDaPiramide.length,
                width: MediaQuery.of(context).size.width * 0.95,
                alignment: Alignment.center,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.piramide.camadasDaPiramide.length,
                  //  abasBloc
                  //     .piramidesController.value[index].camadasDaPiramide.length,
                  itemBuilder: (ctx, camadaIndex) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            //  color: Colors.cyanAccent,
                            //alignment: Alignment.centerLeft,
                            height: MediaQuery.of(context).size.width * 0.12,
                            width: MediaQuery.of(context).size.width *
                                (0.12 * (camadaIndex + 1)),
                            child: CustomPaint(
                              painter: DrawTronco2(camadaIndex),
                              child: InkWell(
                                onTap: () {
                                  //print(infoBloc.informacoesController.value.periodos.length);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VerRelatos(
                                                piramide: widget.piramide,
                                                camada: camadaIndex,
                                                periodo: null,
                                                informacoes: infoBloc
                                                    .informacoesController
                                                    .value,
                                              )));
                                },
                                splashColor: Colors.deepOrange,
                                child: Container(
                                  //  color: Colors.amber,
                                  alignment: Alignment(0, 0.5),
                                  child: Text(
                                    infoBloc
                                        .informacoesController
                                        .value
                                        .periodos[0]
                                        .camadasInfo[camadaIndex]
                                        .totalCamada
                                        .toString(),
                                    // abasBloc.piramidesController.value[index]
                                    //     .camadasDaPiramide[camadaIndex].total
                                    //     .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            //  color: Colors.blue,
                            //alignment: Alignment.centerLeft,
                            height: MediaQuery.of(context).size.width * 0.12,
                            width: MediaQuery.of(context).size.width * (0.35),
                            child: Text(
                              _cortaStringGande(widget.piramide
                                      .camadasDaPiramide[camadaIndex].nome) +
                                  '  (' +
                                  widget.piramide.camadasDaPiramide[camadaIndex]
                                      .porcentagem
                                      .toString() +
                                  '%)',
                              //  ' 33% ',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              //   ),
            ),
            //
            //
            //
            //
            //
            Container(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget _piramideCard(int periIndex) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.blue, width: 1)),
      color: Colors.blue.shade50,
      child: Container(
        //height: 350,
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              //   color: Colors.grey,
              height: 40,
              child: Align(
                alignment: Alignment(0, 0),
                child: Text(
                  'PERÍODO ${periIndex} ( ${infoBloc.informacoesController.value.periodos[periIndex].totalTodasAsCamadas} ) ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
              ),
            ),
            Container(
              //tamaho da card
              // color: Colors.cyanAccent,
              height: MediaQuery.of(context).size.width *
                  0.14 *
                  widget.piramide.camadasDaPiramide.length,
              // abasBloc
              //     .piramidesController.value[index].camadasDaPiramide.length,
              //width: 300,
              alignment: Alignment.center,

              child: Container(
                //tamanho conteiner da piremide
                //   color: Colors.grey,
                height: MediaQuery.of(context).size.width *
                    0.12 *
                    widget.piramide.camadasDaPiramide.length,
                // abasBloc
                //     .piramidesController.value[index].camadasDaPiramide.length,
                width: MediaQuery.of(context).size.width * 0.95,
                alignment: Alignment.center,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.piramide.camadasDaPiramide.length,
                  //  abasBloc
                  //     .piramidesController.value[index].camadasDaPiramide.length,
                  itemBuilder: (ctx, camadaIndex) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            //  color: Colors.cyanAccent,
                            //alignment: Alignment.centerLeft,
                            height: MediaQuery.of(context).size.width * 0.12,
                            width: MediaQuery.of(context).size.width *
                                (0.12 * (camadaIndex + 1)),
                            child: CustomPaint(
                              painter: DrawTronco2(camadaIndex),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VerRelatos(
                                                piramide: widget.piramide,
                                                camada: camadaIndex,
                                                periodo: infoBloc
                                                    .informacoesController
                                                    .value
                                                    .periodos[periIndex],
                                                informacoes: infoBloc
                                                    .informacoesController
                                                    .value,
                                              )));
                                },
                                splashColor: Colors.deepOrange,
                                child: Container(
                                  //  color: Colors.amber,
                                  alignment: Alignment(0, 0.5),
                                  child: Text(
                                    infoBloc
                                        .informacoesController
                                        .value
                                        .periodos[periIndex]
                                        .camadasInfo[camadaIndex]
                                        .totalCamada
                                        .toString(),
                                    // abasBloc.piramidesController.value[index]
                                    //     .camadasDaPiramide[camadaIndex].total
                                    //     .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            //  color: Colors.blue,
                            //alignment: Alignment.centerLeft,
                            height: MediaQuery.of(context).size.width * 0.12,
                            width: MediaQuery.of(context).size.width * (0.35),
                            child: Text(
                              _cortaStringGande(widget.piramide
                                      .camadasDaPiramide[camadaIndex].nome) +
                                  '  (' +
                                  infoBloc
                                      .informacoesController
                                      .value
                                      .periodos[periIndex]
                                      .camadasInfo[camadaIndex]
                                      .porcentagem
                                      .toString() +
                                  '%)',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 100,
              //  color: Colors.redAccent.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Data Início'),
                      Container(
                        width: 15,
                      ),
                      widget.usuarioAdm == false
                          ? Text(_formataData(infoBloc.informacoesController
                              .value.periodos[periIndex].dataInicio))
                          : RaisedButton(
                              child: Text(_formataData(infoBloc
                                  .informacoesController
                                  .value
                                  .periodos[periIndex]
                                  .dataInicio)),
                              onPressed: () async {
                                setState(() {
                                  podeSalvar = true;
                                });
                                await _selectDateInicio(periIndex);
                                infoBloc.recalcularInfoPeriodo(periIndex);
                              },
                            ),

                      // Text(_formataData(infoBloc.informacoesController.value
                      //     .periodos[periIndex].dataInicio)),
                    ],
                  ),
                  Visibility(
                    visible: infoBloc.informacoesController.value
                            .periodos[periIndex].dataFim !=
                        null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Data Fim'),
                        Container(
                          width: 27,
                        ),
                        widget.usuarioAdm == false
                            ? Text(_formataData(infoBloc.informacoesController
                                .value.periodos[periIndex].dataFim))
                            : RaisedButton(
                                child: Text(_formataData(infoBloc
                                    .informacoesController
                                    .value
                                    .periodos[periIndex]
                                    .dataFim)),
                                onPressed: () async {
                                  setState(() {
                                    podeSalvar = true;
                                  });
                                  await _selectDateFim(periIndex);
                                  infoBloc.recalcularInfoPeriodo(periIndex);
                                },
                              ),

                        // Text(_formataData(infoBloc.informacoesController.value
                        //     .periodos[periIndex].dataInicio)),
                      ],
                    ),
                  )
                  ,

                   Visibility(
                    visible: infoBloc.informacoesController.value
                            .periodos[periIndex].dataFim ==
                        null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Data Fim'),
                        Container(
                          width: 27,
                        ),
                       Text(_formataData(infoBloc.informacoesController
                                .value.periodos[periIndex].dataFim))
                           ,

                        // Text(_formataData(infoBloc.informacoesController.value
                        //     .periodos[periIndex].dataInicio)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  String _cortaStringGande(String string) {
    if (string.length > 30) {
      return string = string.substring(0, 30);
    } else {
      return string;
    }
  }

//  String _value = 'ggg';
  Future _selectDateInicio(int periIndex) async {
    DateTime d = DateTime.parse(
        infoBloc.informacoesController.value.periodos[periIndex].dataInicio);
    //  String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(t);

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: d,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null) {
      infoBloc.informacoesController.value.periodos[periIndex].dataInicio =
          picked.toIso8601String();
      infoBloc.informacoesEvent.add(infoBloc.informacoesController.value);
    }
    //  setState(() => _value = formatDate(picked, [dd, '/', mm, '/', yyyy]));
  }

  Future _selectDateFim(int periIndex) async {
    DateTime d;
    if (infoBloc.informacoesController.value.periodos[periIndex].dataFim ==
        null) {
      d = DateTime.now();
    } else {
      d = DateTime.parse(
          infoBloc.informacoesController.value.periodos[periIndex].dataFim);
    }
    //  String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(t);

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: d,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    if (picked != null) {
      picked = picked.add(
        Duration(hours: 23, seconds: 59, minutes: 59),
      );
      DateTime di = DateTime.parse(
          infoBloc.informacoesController.value.periodos[periIndex].dataInicio);
      if (picked.isAfter(di)) {
        print('object');
        print(picked.toString());
        infoBloc.informacoesController.value.periodos[periIndex].dataFim =
            picked.toIso8601String();
        infoBloc.informacoesEvent.add(infoBloc.informacoesController.value);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('ATENÇÃO'),
                content: Text('Data Fim tem q ser depois de Data Início'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    }
  }

  String _formataData(String data) {
    if (data == null) {
      return '   ABERTA   ';
    }
    DateTime t = DateTime.parse(data);
    String formattedDate = DateFormat('dd/MM/yyyy').format(t);
    //  print('11111');
    //  print(formattedDate);
    return formattedDate;
  }
}
