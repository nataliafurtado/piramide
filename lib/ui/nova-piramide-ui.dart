import 'dart:math';
import 'package:comportamentocoletivo/aux/draw-tronco.dart';
//import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/model/camada.dart';
import 'package:comportamentocoletivo/model/enums.dart';
//import 'package:comportamentocoletivo/bloc/nova-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/pergunta.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:comportamentocoletivo/ui/configuracoes-piramide.dart';
import 'package:comportamentocoletivo/ui/piramides-ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum OrderOptions { comofunciona, logout }

class NovaPiramide extends StatefulWidget {
  final piramidesModeloEnum modelo;
  NovaPiramide({this.modelo});
  static const route = '/nova-piramide';

  @override
  _NovaPiramideState createState() => _NovaPiramideState();
}

class _NovaPiramideState extends State<NovaPiramide> {
  @override
  void initState() {
    bloc.carregaModelo(widget.modelo);
    super.initState();
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.comofunciona:
        //  _mostrarExcluir = !_mostrarExcluir;
        break;
      case OrderOptions.logout:
        // _autenticacao.signOut().then((_) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => MyApp()));
        // });

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

  TextEditingController txNomecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NOVA PIRÂMIDE'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                // print('hnhnhnhnhn');
                await bloc.cpiEvent.add(true);
                String aviso = await bloc.salvarNovaPiramide();
                await bloc.cpiEvent.add(false);

                if (aviso != null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ATENÇÃO'),
                          content: Text(aviso),
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
                } else {
                  Navigator.of(context).pop();

//  Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => AbaUi(
//                         aba: 0,
//                       )));

                  Navigator.pushNamedAndRemoveUntil(
                      context, AbaUi.route, ModalRoute.withName(AbaUi.route));
                }

                // Navigator.of(context).pop();
              },
              child: Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // PopupMenuButton<OrderOptions>(
            //   itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
            //     const PopupMenuItem<OrderOptions>(
            //       child: Text("Como funciona ?"),
            //       value: OrderOptions.comofunciona,
            //     ),
            //     const PopupMenuItem<OrderOptions>(
            //       child: Text("Sair"),
            //       value: OrderOptions.logout,
            //     ),
            //   ],
            //   onSelected: _orderList,
            // ),
          ],
        ),
        body: StreamBuilder(
          stream: bloc.cpiFluxo,
          builder: (ctx, snappp) {
            if (snappp.data != null && snappp.data == true) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: <Widget>[
                  Container(
                    height: 80,
                    color: Colors.blueGrey.shade50,
                    child: Center(
                      child: TextField(
                        controller: txNomecontroller,
                        onChanged: (value) {
                          if (txNomecontroller.text != value.toUpperCase())
                            txNomecontroller.value = txNomecontroller.value
                                .copyWith(text: value.toUpperCase());

                          bloc.nomePiramide(value.toUpperCase());
                        },
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.change_history),
                            hintText: 'Informe um nome'),
                      ),
                    ),
                  ),
                  //       Divider(color: Colors.black, height: .1),

                  Container(
                    height: 85,
                    alignment: Alignment.center,
                    // color: Colors.limeAccent,
                    child: SizedBox(
                      height: 45,
                      child: RaisedButton.icon(
                        icon: Icon(Icons.settings),
                        label: Text('    Configurações    '),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfiguracoesPiramide(
                                        piramide: bloc.piramideController.value,
                                      )));
                          // ConfiguracoesPiramide(bloc.piramideController.value)
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    //color: Colors.yellowAccent,
                    child: Center(child: Text('SELECIONE UMA CAMADA:')),
                  ),
                  Container(
                    height: 310,
                    //color: Colors.yellowAccent,
                    child: StreamBuilder(
                      stream: bloc.camadaFluxo,
                      builder: (context, snappp) {
                        return StreamBuilder(
                          stream: bloc.camadaSelecinadaFluxo,
                          builder: (context, snappp) {
                            return _piramideCard(context);
                          },
                        );
                      },
                    ),
                  ),
                  //  Divider(color: Colors.black, height: .1),
                  Container(
                    height: 30,
                    //color: Colors.yellowAccent,
                    child: Center(
                        child: Text('CONFIGURE AS PERGUNTAS POR CAMADA:')),
                  ),
                  Container(
                    height: 660,
                    padding: EdgeInsets.all(5),
//decoration:   BoxDecoration(border: Border.(color: Colors.blueGrey)),
                    //color: Colors.yellowAccent,
                    child: StreamBuilder(
                      stream: bloc.camadaFluxo,
                      builder: (context, snappp) {
                        return StreamBuilder(
                          stream: bloc.camadaSelecinadaFluxo,
                          builder: (context, snappp) {
                            return _editarCamadaPiramide(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}

Widget _editarCamadaPiramide(BuildContext context) {
  return Container(
    color: Colors.blueGrey.shade50,
    child: Column(
      children: <Widget>[
        Container(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width * 0.12,
            width: MediaQuery.of(context).size.width * (0.12 * (2 + 1)),
            child: CustomPaint(
              painter: DrawTronco(bloc.camadaSelecinadaController.value,
                  bloc.camadasController.value.length),
              child: Container(
                //  color: Colors.amber,
                alignment: Alignment(0, 0.5),
              ),
            ),
          ),
          Text(bloc.camadasController
              .value[bloc.camadaSelecinadaController.value].nome)
        ]),
        Container(
          height: 30,
        ),
        _perguntaAberta(context),
      ],
    ),
  );
}

Widget _perguntaAberta(BuildContext context) {
  return Container(
    // color: Colors.brown.shade100,
    height: MediaQuery.of(context).size.height * 0.75,
    child: ListView.builder(
      itemCount: bloc.perguntasLength() + 1,
      // ? bloc.camadasLength() + 1
      // : bloc.camadasLength(),
      itemBuilder: (ctx, ind) {
        return ind == bloc.perguntasLength() //&& bloc.camadasLength() <=3
            ? Container(
                color: Colors.white70,
                height: 50,
                child: Center(
                  child: SizedBox(
                    height: 45,
                    child: FlatButton.icon(
                      icon: Icon(Icons.add_circle),
                      label: Text('ADD NOVA PERGUNTA'),
                      onPressed: () {
                        bloc.addNovaPergunta();
                      },
                    ),
                  ),
                ),
              )
            : Card(
                // color: Colors.cyan,
                elevation: 3,
                //   decoration:   BoxDecoration(border: Border.all(color: Colors.blueGrey)),
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 20,
                            child: Text('Pergunta ${ind + 1}'),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.redAccent.shade200,
                            ),
                            onPressed: () {
                              bloc.removerPergunta(ind);
                            },
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('OBRIGATÓRIA'),
                        Checkbox(
                          value: bloc
                              .camadaSelecionada()
                              .perguntaDaCamada[ind]
                              .obrigatoria,
                          onChanged: (obrigatoriaCheck) {
                            bloc.alteraCheckBox(ind, obrigatoriaCheck);
                          },
                        ),
                      ],
                    ),
                    DropdownButton<perguntasEnum>(
                      hint: Text('Escolha uma Pergunta'),
                      value: bloc
                          .camadaSelecionada()
                          .perguntaDaCamada[ind]
                          .perguntaEnum,
                      items: perguntasEnum.values.map((perguntasEnum value) {
                        return new DropdownMenuItem<perguntasEnum>(
                          value: value,
                          child: new Text(
                              PerguntasEnumConverter().converter(value)),
                        );
                      }).toList(),
                      onChanged: (novoEnum) {
                        bloc.alteraPergunta(ind, novoEnum);
                      },
                    )
                  ],
                ));
      },
    ),
  );
}

String rrr() {
  var random = Random.secure();

  return random.nextInt(1000000000).toString();
}

Widget _piramideCard(BuildContext context) {
  return Container(
    color: Colors.blueGrey.shade50,
    child: Column(
      //    mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 300,
          //width: 300,
          alignment: Alignment.center,
          child: Container(
            //    color: Colors.grey,
            height: MediaQuery.of(context).size.width * 0.12 * 5,
            width: MediaQuery.of(context).size.width * 0.95,
            alignment: Alignment.center,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              key: Key(UniqueKey().toString()),

              itemCount: bloc.camadasController.value.length <= 4
                  ? bloc.camadasController.value.length + 1
                  : bloc.camadasController.value.length,
              itemBuilder: (ctx, ii) {
                return ii == (bloc.camadasController.value.length) &&
                        bloc.camadasController.value.length <= 4
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              //  color: Colors.cyanAccent,
                              //alignment: Alignment.centerLeft,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width *
                                  (0.12 * (ii + 1)),
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () {},
                                child: CustomPaint(
                                  painter: DrawTroncoUltimo(ii),
                                  child: Container(
                                      //  color: Colors.amber,
                                      alignment: Alignment(0, 0.5),
                                      child: Align(
                                        child: FlatButton.icon(
                                          onPressed: () {
                                            bloc.addNovaCamada();
                                          },
                                          icon: Icon(Icons.add_circle),
                                          label: Text('ADD'),
                                        ),
                                      )),
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
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () {},
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '',
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              //  color: Colors.cyanAccent,
                              //alignment: Alignment.centerLeft,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width *
                                  (0.12 * (ii + 1)),
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () async {
                                  // print(ii);
                                  // print('size ' +
                                  //     bloc.camadasController.value.length
                                  //         .toString());
                                  // if (ii == 2) {
                                  //   bloc.camadaSelecinadaEvent.add(0);
                                  //   await Duration(seconds: 2);
                                  // } else {

                                  bloc.camadaSelecinadaEvent.add(ii);
                                  //    }
                                },
                                child: CustomPaint(
                                  painter: DrawTronco(
                                      ii, bloc.camadasController.value.length),
                                  child: Container(
                                      color: ii ==
                                              bloc.camadaSelecinadaController
                                                  .value
                                          ? Colors.transparent.withAlpha(70)
                                          : Colors.transparent,
                                      alignment: Alignment(0, 0.5),
                                      child: Visibility(
                                        visible: bloc.camadasController.value
                                                    .length ==
                                                (ii + 1)
                                            ? true
                                            : false,
                                        // visible: true,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.redAccent.shade200,
                                          ),
                                          onPressed: () {
                                            // print('eeeeeeee' + ii.toString());
                                            // print('sizefffff ' +
                                            //     bloc.camadasController.value
                                            //         .length
                                            //         .toString());
                                            //   bloc.atualizarMerda();
                                            bloc.camadaSelecinadaEvent.add(0);
                                            bloc.removeCamada(ii);
                                          },
                                        ),
                                      )
                                      // child: Text(
                                      //   '',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              color: ii == bloc.camadaSelecinadaController.value
                                  ? Colors.transparent.withAlpha(70)
                                  : Colors.transparent,
                              //  color: Colors.blue,
                              //alignment: Alignment.centerLeft,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * (0.35),
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () {
                                  // print(
                                  //     bloc.camadasController.value.toString());
                                },
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      initialValue:
                                          bloc.camadasController.value[ii].nome,
                                      onChanged: (text) {
                                        bloc.camadasController.value[ii].nome =
                                            text;
                                      },
                                    )),
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

        // Container(
        //   height: 85,
        //   alignment: Alignment.center,
        //   // color: Colors.limeAccent,
        //   child: SizedBox(
        //     height: 45,
        //     child: RaisedButton.icon(
        //       icon: Icon(Icons.settings),
        //       label: Text('    hhththt    '),
        //       onPressed: () {
        //         // bloc.piramideEvent.add(Piramide(nome: 'kkkkkk'));
        //         print('rrr');
        //         print(bloc.camadasController.value[0].nome);
        //       },
        //     ),
        //   ),
        // )
      ],
    ),
  );
}

class DrawTroncoUltimo extends CustomPainter {
  Paint _paint;
  int multi;

  DrawTroncoUltimo(this.multi) {
    _paint = Paint()
      // ..color = Colors.orangeAccent
      ..style = PaintingStyle.fill;
  }

  int _multiplicador(int mu) {
    return 2 + mu * 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int m = _multiplicador(multi);
    _paint.color = Colors.white70;
    var path = Path();
    path.moveTo(size.width / m, 0);
    path.lineTo((size.width * (m - 1)) / m, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    //path.lineTo(0 , );
    //path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
