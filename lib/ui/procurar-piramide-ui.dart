import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/procurar-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/usuario.dart';
import 'package:flutter/material.dart';

ProcurarPiramideBloc blocProcPiramide =
    BlocProvider.getBloc<ProcurarPiramideBloc>();

class ProcurarPiramide extends StatefulWidget {
  static const route = '/procurar-piramide';

  @override
  _ProcurarPiramideState createState() => _ProcurarPiramideState();
}

class _ProcurarPiramideState extends State<ProcurarPiramide> {
  GlobalKey<AutoCompleteTextFieldState<Piramide>> key = GlobalKey();
  List<Usuario> lisUser = [
    Usuario(nome: 'dddd'),
    Usuario(nome: 'DAE'),
    Usuario(nome: 'ddDERdd'),
    Usuario(nome: 'DFT'),
    Usuario(nome: 'DAER'),
    Usuario(nome: 'DCBT'),
    Usuario(nome: 'DKMIU'),
    Usuario(nome: 'DYHNDC'),
    Usuario(nome: 'DFRFGR'),
    Usuario(nome: 'GTTG'),
    Usuario(nome: 'dddd'),
    Usuario(nome: 'DRFR'),
  ];

  List<Usuario> lisUser2 = [
    Usuario(nome: 'cacac'),
    Usuario(nome: 'cacac'),
    Usuario(nome: 'ccacacddcacaDERdd'),
  ];
  @override
  void initState() {
    blocProcPiramide = ProcurarPiramideBloc();
blocProcPiramide.carragaPublicos();
    super.initState();
  }

  @override
  void dispose() {
    blocProcPiramide.dispose();
    super.dispose();
  }

  TextEditingController txNomecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROCURAR PIRÂMIDE'),
      ),
      body: StreamBuilder(
          stream: blocProcPiramide.piramidesFluxo,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    // RaisedButton(
                    //   onPressed: () {
                    //     print('to sringo');
                    //     for (var i = 0; i < snapshot.data.length; i++) {
                    //       print(snapshot.data[i].nome);
                    //     }
                    //   },
                    //   child: Text('snapshot.data[0].nome'),
                    // ),

                    Container(
                      height: 80,
                      color: Colors.blue.shade50,
                      child: Center(
                        child: TextField(
                          controller: txNomecontroller,
                          onChanged: (tx) {
                            if (txNomecontroller.text != tx.toUpperCase())
                              txNomecontroller.value = txNomecontroller.value
                                  .copyWith(text: tx.toUpperCase());

                            if (tx.isNotEmpty && tx.length > 2) {
                              blocProcPiramide
                                  .carregaPiramides(tx.toUpperCase());
                            } else {
                              blocProcPiramide.piramidesEvent.add([]);
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.change_history),
                              hintText: 'Informe um nome'),
                        ),
                      ),
                    ),

                    Container(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      //color: Colors.blue,
                      child: ListView.builder(
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            splashColor: Colors.orange,
                            onTap: () {
                              if (snapshot.data[index].publica) {
                                blocProcPiramide.aceitarUsuario(
                                    snapshot.data[index].piramideId);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('AVISO'),
                                        content: Text(
                                            'Agora voçe pode realizar Relatos para essa piramide'),
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
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('PEDIDO DE PARTICIPAÇÃO'),
                                        content: Text(
                                            'Gostaria de pedir autorização para participar dessa piramide ?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              blocProcPiramide.novoPedido(
                                                  snapshot
                                                      .data[index].piramideId);
                                              Navigator.of(context).pop();

                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('AVISO'),
                                                      content: Text(
                                                          'Pedido realizado com sucesso. Aguarde ADM da piramide aceitar pedido.'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text('SIM'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('NÃO'),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Card(
                              color: Colors.blue.shade50,
                              elevation: 5,
                              // height: 40,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(snapshot.data[index].nome),
                                    snapshot.data[index].publica
                                        ? Icon(Icons.lock_open,
                                            color: Colors.blueAccent)
                                        : Icon(Icons.lock,
                                            color: Colors.blueAccent)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _row(Piramide item) {
    return Row(
      children: <Widget>[
        Text(
          item.nome,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }

  void _carregaPiramides(String text) {
    //&& text.length>1
    if (text != null && text.isNotEmpty) {
      print("frjujuj");
      blocProcPiramide.carregaPiramides(text);
      setState(() {});
    }
    // print("bunca");
  }
}
