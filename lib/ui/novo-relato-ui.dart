import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/novo-relato-bloc.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

NovoRelatoBloc novoRelatoBloc = BlocProvider.getBloc<NovoRelatoBloc>();

class NovoRelato extends StatefulWidget {
  final Piramide piramide;
  final int camadaIndex;

  NovoRelato({this.piramide, this.camadaIndex});
  static const route = '/novo-relato';

  @override
  _NovoRelatoState createState() => _NovoRelatoState();
}

class _NovoRelatoState extends State<NovoRelato> {
  AutoCompleteTextField search;

  bool mostrarCircularProgress = false;

  @override
  void initState() {
    novoRelatoBloc = NovoRelatoBloc();
    novoRelatoBloc.carregaPerguntas(
        widget.piramide.piramideId, widget.camadaIndex);
    super.initState();
  }

  Widget _perguntaAberta(BuildContext context) {
    return Container(
      // color: Colors.brown.shade100,
      height: MediaQuery.of(context).size.height * 0.70,
      child: ListView.builder(
        itemCount: novoRelatoBloc.perguntasRelatoController.value.length,
        // ? bloc.camadasLength() + 1
        // : bloc.camadasLength(),
        itemBuilder: (ctx, indexPergunta) {
          // print('indexPergunta' +indexPergunta.toString());
          return Card(
              // color: Colors.cyan,
              elevation: 3,
              //   decoration:   BoxDecoration(border: Border.all(color: Colors.blueGrey)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            novoRelatoBloc.perguntasRelatoController
                                    .value[indexPergunta].obrigatoria
                                ? '(*)  '
                                : '',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                            ),
                          ),
                          Text(PerguntasEnumConverter().converter(novoRelatoBloc
                              .perguntasRelatoController
                              .value[indexPergunta]
                              .perguntaEnum)),
                        ]),
                    Center(
                      child: _resposta(
                          novoRelatoBloc.perguntasRelatoController
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
      color: Colors.blueGrey.shade50,
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
                child: Text(widget.piramide.camadasDaPiramide[widget.camadaIndex].nome),
              )
            ],
          ),
          Container(
            height: 30,
          ),
          StreamBuilder(
              stream: novoRelatoBloc.perguntasRelatoFluxo,
              builder: (context, snapshot) {
                return _perguntaAberta(context);
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                String aviso = await novoRelatoBloc.novoRelato(
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
                // Navigator.pushNamedAndRemoveUntil(
                //     context, AbaUi.route, ModalRoute.withName(AbaUi.route));
              },
            )
          ],
          title: Text(widget.piramide.nome),
        ),
        body: mostrarCircularProgress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(child: _perguntas(context)));
  }

  List<Usuario> lisUser = [Usuario(nome: 'dddd'), Usuario(nome: 'ummm')];

  Widget _resposta(perguntasEnum perguntaEnum, int indexPergunta) {
    GlobalKey<AutoCompleteTextFieldState<Usuario>> key = GlobalKey();
    if (perguntaEnum == perguntasEnum.onde ||
        perguntaEnum == perguntasEnum.como ||
        perguntaEnum == perguntasEnum.porque ||
        perguntaEnum == perguntasEnum.oque) {
      return TextField(
        onChanged: (tx) {
          novoRelatoBloc
              .perguntasRelatoController.value[indexPergunta].resposta = tx;
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            // icon: Icon(Icons.change_history),
            hintText: 'Resposta'),
      );
    } else if (perguntaEnum == perguntasEnum.quando) {
      return Column(
        children: <Widget>[
          RaisedButton(
            onPressed: _selectDate,
            child: new Text(_value),
          ),
          RaisedButton(
            onPressed: _selectTime,
            child: new Text(_value1),
          )
        ],
      );
    } else if (perguntaEnum == perguntasEnum.quem) {
      return Column(
        children: <Widget>[
          search = AutoCompleteTextField<Usuario>(
            key: key,
            clearOnSubmit: false,
            suggestions: lisUser,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(hintText: 'Procure um usuário'),
            itemFilter: (item, query) {
              return item.nome.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.nome.compareTo(b.nome);
            },
            itemSubmitted: (item) {
              setState(() {
                search.textField.controller.text = item.nome;
              });
            },
            itemBuilder: (ctx, item) {
              return _row(item);
            },
          )
        ],
      );
    }
    return null;
  }

  String _value = 'Selecione uma data:';
  String _value1 = 'Selecione uma hora:';
  Future _selectTime() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() => _value1 = _cortarDateTime(picked.toString()));
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null)
      setState(() => _value = formatDate(picked, [dd, '/', mm, '/', yyyy]));
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
