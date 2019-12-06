import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/relato-bloc.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/informacoes.dart';
import 'package:comportamentocoletivo/model/periodo.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

RelatoBloc blocnovoRelat = BlocProvider.getBloc<RelatoBloc>();

class RelatoUIEditavel extends StatefulWidget {
  final Piramide piramide;
  final int camadaIndex;

  final Relato relato;
  final Periodo periodo;
  final Informacoes informacoes;
  final String usuarioLogadoId;

  RelatoUIEditavel(
      {this.piramide,
      this.camadaIndex,
      this.relato,
      this.periodo,
      this.informacoes,
      this.usuarioLogadoId});
  static const route = '/novo-relato';

  @override
  _RelatoUIEditavelState createState() => _RelatoUIEditavelState();
}

class _RelatoUIEditavelState extends State<RelatoUIEditavel> {
  AutoCompleteTextField search;

  bool mostrarCircularProgress = false;

  @override
  void initState() {
    blocnovoRelat = RelatoBloc();
    if (widget.relato == null) {
      blocnovoRelat.carregaPerguntas(widget.piramide, widget.camadaIndex);
    } else {
      blocnovoRelat.carregaPerguntasRelatoVelho(widget.relato);
    }
    // mostrarCircularProgress = false;
    super.initState();
  }

  Widget _perguntaAberta(BuildContext context, AsyncSnapshot<dynamic> snap) {
    return Container(
      // color: Colors.brown.shade100,
      height: MediaQuery.of(context).size.height * 0.70,
      child: ListView.builder(
        itemCount: blocnovoRelat.perguntasRelatoController.value.length,
        // ? bloc.camadasLength() + 1
        // : bloc.camadasLength(),
        itemBuilder: (ctx, indexPergunta) {
          // print('indexPergunta' +indexPergunta.toString());
          return Card(
              // color: Colors.cyan,
              elevation: 3,
              //   decoration:   BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            blocnovoRelat.perguntasRelatoController
                                    .value[indexPergunta].obrigatoria
                                ? '(*)  '
                                : '',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                            ),
                          ),
                          Text(PerguntasEnumConverter().converter(blocnovoRelat
                              .perguntasRelatoController
                              .value[indexPergunta]
                              .perguntaEnum)),
                        ]),
                    Center(
                      child: _resposta(
                          blocnovoRelat.perguntasRelatoController
                              .value[indexPergunta].perguntaEnum,
                          indexPergunta),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget _perguntas(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * (0.12 * (2 + 1)),
                child: CustomPaint(
                  painter: DrawTronco(widget.camadaIndex,
                      widget.piramide.camadasDaPiramide.length),
                  child: Container(
                    //  color: Colors.amber,
                    alignment: Alignment(0, 0.5),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                    widget.piramide.camadasDaPiramide[widget.camadaIndex].nome),
              )
            ],
          ),
          Container(
            height: 30,
          ),
          Container(
              height: 40,
              alignment: Alignment.center,
              // color: Colors.limeAccent,
              child:
                  //  SizedBox(
                  //   height: 45,
                  //   child:
                  // Text('data')

                  StreamBuilder(
                      stream: blocnovoRelat.normalFluxo,
                      builder: (context, snapPiramide) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                blocnovoRelat.normalController.value =
                                    !blocnovoRelat.normalController.value;
                                blocnovoRelat.normalEvent
                                    .add(blocnovoRelat.normalController.value);
                              },
                              child: Container(
                                height: 40,
                                width: 75,
                                decoration: BoxDecoration(
                                  color: blocnovoRelat.normalController.value
                                      ? Colors.blue.shade400
                                      : Colors.grey.shade200,
                                  //border: Border.all(width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          3.0) //         <--- border radius here
                                      ),
                                ),
                                child: Center(
                                  child: Text('NORMAL'),
                                ),
                              ),
                            ),
                            Switch(
                              value: !blocnovoRelat.normalController.value,
                              onChanged: (value) {
                                blocnovoRelat.normalController.value =
                                    !blocnovoRelat.normalController.value;
                                blocnovoRelat.normalEvent
                                    .add(blocnovoRelat.normalController.value);
                              },
                              activeTrackColor: Colors.orange.shade200,
                              activeColor: Colors.orange,
                              inactiveThumbColor: Colors.blue,
                              inactiveTrackColor: Colors.blue.shade100,
                            ),
                            InkWell(
                              onTap: () {
                                blocnovoRelat.normalController.value =
                                    !blocnovoRelat.normalController.value;
                                blocnovoRelat.normalEvent
                                    .add(blocnovoRelat.normalController.value);
                              },
                              child: Container(
                                height: 40,
                                width: 75,
                                decoration: BoxDecoration(
                                  color: blocnovoRelat.normalController.value
                                      ? Colors.grey.shade200
                                      : Colors.orangeAccent,
                                  //border: Border.all(width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          3.0) //         <--- border radius here
                                      ),
                                ),
                                child: Center(
                                  child: Text('ANÔNIMA'),
                                ),
                              ),
                            ),
                          ],
                        );
                      })),
          Container(
            height: 15,
          ),
          StreamBuilder(
              stream: blocnovoRelat.perguntasRelatoFluxo,
              // initialData:[] ,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : _perguntaAberta(context, snapshot);
              }),
        ],
      ),
    );
  }

  double bannerAjuste = 48;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bannerAjuste),
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  setState(() {
                    mostrarCircularProgress = true;
                  });
                  if (widget.relato != null) {
                    String aviso = await blocnovoRelat.salvarRelato(
                        widget.piramide, widget.relato);
                    if (aviso == null) {
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        mostrarCircularProgress = false;
                      });
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
                    }
                  } else {
                    String aviso = await blocnovoRelat.novoRelato(
                        widget.piramide, widget.camadaIndex);
                    if (aviso == null) {
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        mostrarCircularProgress = false;
                      });
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
                    }
                  }
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, AbaUi.route, ModalRoute.withName(AbaUi.route));
                },
              )
            ],
            title: Text(widget.piramide.nome),
          ),
          body: StreamBuilder(
            stream: blocnovoRelat.semSaldoFluxo,
            builder: (ctx, snap3) {
              return Center(
                child: blocnovoRelat.semSaldoController.value
                    ? Container(
                        height: 200,
                        width: 200,
                        child: Text(
                            'Sem saldo: Entre em contato com administrador(a) da Pirâmide'),
                      )
                    : mostrarCircularProgress
                        //|| blocnovoRelat.perguntasRelatoController.value==null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(child: _perguntas(context)),
              );
            },
          )),
    );
  }

  List<Usuario> lisUser = [Usuario(nome: 'dddd'), Usuario(nome: 'ummm')];

  Widget _resposta(perguntasEnum perguntaEnum, int indexPergunta) {
    GlobalKey<AutoCompleteTextFieldState<Usuario>> key = GlobalKey();
    List<String> tempo =
        blocnovoRelat.respostasController.value[indexPergunta].text.split(":");
    if (perguntaEnum == perguntasEnum.onde ||
        perguntaEnum == perguntasEnum.como ||
        perguntaEnum == perguntasEnum.porque ||
        perguntaEnum == perguntasEnum.oque) {
      return TextField(
        controller: blocnovoRelat.respostasController.value[indexPergunta],
        onChanged: (tx) {
          blocnovoRelat
              .perguntasRelatoController.value[indexPergunta].resposta = tx;
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            // icon: Icon(Icons.change_history),
            hintText: 'Resposta'),
      );
    } else if (perguntaEnum == perguntasEnum.quando) {
      // String _value = 'Selecione uma data:';
      //String _value1 = 'Selecione uma hora:';

      Future _selectTime() async {
        TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: (widget.relato == null || tempo.length <= 2)
              ? TimeOfDay.now()
              : TimeOfDay(
                  hour: int.parse(tempo[1].trim()),
                  minute: int.parse(tempo[2].trim())),
        );
        if (picked != null) {
          if (blocnovoRelat
                  .perguntasRelatoController.value[indexPergunta].resposta ==
              null) {
            blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta =
                '00/00/0000 : ' +
                    picked.hour.toString() +
                    ':' +
                    picked.minute.toString();
          } else {
            blocnovoRelat.perguntasRelatoController.value[indexPergunta]
                .resposta = blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta
                    .substring(0, 10) +
                ' : ' +
                picked.hour.toString() +
                ':' +
                picked.minute.toString();
          }
        }
        blocnovoRelat.perguntasRelatoEvent
            .add(blocnovoRelat.perguntasRelatoController.value);
      }

      Future _selectDate() async {
      //  print(tempo[0].trim());
        DateFormat dateFormat = DateFormat("dd/MM/yyyy");
        DateTime data = DateTime.now();
        if (tempo[0].isNotEmpty) {
          DateTime data = dateFormat.parse(tempo[0].trim());
        }
        DateTime picked = await showDatePicker(
            context: context,
            initialDate: (widget.relato == null || tempo.length <= 2)
                ? DateTime.now()
                : data,
            firstDate: new DateTime(2016),
            lastDate: new DateTime(2020));
        if (picked != null) {
          if (blocnovoRelat
                  .perguntasRelatoController.value[indexPergunta].resposta ==
              null) {
            blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta =
                formatDate(picked, [dd, '/', mm, '/', yyyy]) + ' : 00:00';
          } else {
            blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta =
                formatDate(picked, [dd, '/', mm, '/', yyyy]) +
                    blocnovoRelat
                        .perguntasRelatoController.value[indexPergunta].resposta
                        .substring(10);
          }
        }
        blocnovoRelat.perguntasRelatoEvent
            .add(blocnovoRelat.perguntasRelatoController.value);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: _selectDate,
            child: Text(blocnovoRelat.perguntasRelatoController
                        .value[indexPergunta].resposta ==
                    null
                ? "DATA"
                : blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta
                    .substring(0, 10)),
          ),
          Container(
            width: 15,
          ),
          RaisedButton(
            onPressed: _selectTime,
            child: Text(blocnovoRelat.perguntasRelatoController
                        .value[indexPergunta].resposta ==
                    null
                ? "HORA"
                : blocnovoRelat
                    .perguntasRelatoController.value[indexPergunta].resposta
                    .substring(13)),
          ),
          Container(
            width: 15,
          ),
        ],
      );
    } else if (perguntaEnum == perguntasEnum.quem) {
      TextEditingController controller = TextEditingController();
      if (widget.relato != null) {
     
        controller.text= blocnovoRelat.respostasController.value[indexPergunta].text;
      }
      return StreamBuilder(
        initialData: [],
        stream: blocnovoRelat.usuariosFluxo,
        builder: (ctx, snapshotUsuarios) {
          // String txx;
          return Column(
            children: <Widget>[
              Container(
                height: 60,
                color: Colors.blue.shade50,
                child: Center(
                  child: TextField(
                    controller: controller,
                    onChanged: (tx) {
                      // txx = tx;
                      if (tx.isNotEmpty && tx.length > 2) {
                        // blocUsuarios.txEvent.add(tx);
                        blocnovoRelat.carregaUsuarios(
                          tx,
                          widget.piramide.piramideId,
                        );
                      } else {
                        // verRealatoBloc.relatoEvent.add([]);
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person),
                        hintText: 'Informe um nome'),
                  ),
                ),
              ),
              Container(
                  height: (snapshotUsuarios.data.length == 0
                          ? 0
                          : MediaQuery.of(context).size.height * 0.5) +
                      100 * snapshotUsuarios.data.length.toDouble(),
                  // color: Colors.blue.shade100,
                  child: ListView.builder(
                    itemCount: snapshotUsuarios.data == null
                        ? 0
                        : snapshotUsuarios.data.length,
                    itemBuilder: (ctx, indexUsuarios) {
                      return InkWell(
                        splashColor: Colors.orange,
                        onTap: () {
                          controller.text = blocnovoRelat
                              .usuariosController.value[indexUsuarios].nome;
                          blocnovoRelat.colocaNomeUsuarioNaResposta(
                              indexUsuarios, indexPergunta);
                          blocnovoRelat.usuariosEvent.add([]);
                        },
                        child: Card(
                          elevation: 7,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(snapshotUsuarios
                                      .data[indexUsuarios].nome),
                                ],
                              )),
                        ),
                      );
                    },
                  )),
            ],
          );
        },
      );
    }
    return null;
  }

  String _cortarDateTime(String time) {
    return time.substring(10, 15);
  }

  Widget _row(Usuario item) {
    return Row(
      children: <Widget>[
        Text(
          item.nome,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
