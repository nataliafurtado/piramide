import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/usuarios-bloc.dart';
import 'package:flutter/material.dart';

UsuariosBloc blocUsuarios = BlocProvider.getBloc<UsuariosBloc>();

class UsuariosUi extends StatefulWidget {
  static const route = '/usuarios';

  final String pramideId;
  UsuariosUi({this.pramideId});
  @override
  _UsuariosUiState createState() => _UsuariosUiState();
}

class _UsuariosUiState extends State<UsuariosUi> {
  @override
  void dispose() {
    blocUsuarios.dispose();
    super.dispose();
  }

  @override
  void initState() {
    blocUsuarios = UsuariosBloc();

    blocUsuarios.carregaVazio(widget.pramideId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: blocUsuarios.txFluxo,
      builder: (ctx, snaptx) {
        return StreamBuilder(
          stream: blocUsuarios.usuariosFluxo,
          builder: (ctx, snapshotUsuarios) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      color: Colors.blueGrey.shade50,
                      child: Center(
                        child: TextField(
                          controller: blocUsuarios.txController.value,
                          onChanged: (tx) {
                            if (tx.isNotEmpty && tx.length > 2) {
                              // blocUsuarios.txEvent.add(tx);

                              blocUsuarios.carregaUsuarios(
                                tx,
                                widget.pramideId,
                              );
                            } else {
                              // verRealatoBloc.relatoEvent.add([]);
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
                        height: MediaQuery.of(context).size.height * 0.6,
                        // color: Colors.blueGrey.shade100,
                        child: ListView.builder(
                          itemCount: snapshotUsuarios.data == null
                              ? 0
                              : snapshotUsuarios.data.length,
                          itemBuilder: (ctx, indexUsuarios) {
                            return Card(
                              elevation: 7,
                              child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshotUsuarios
                                          .data[indexUsuarios].nome),
                                      IconButton(
                                        color: Colors.redAccent,
                                        icon: Icon(Icons.not_interested),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('ATENÇÃO'),
                                                  content: Text('Usuário será excluido dessa pirâmide.'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('CANCELAR'),
                                                    ),
                                                     FlatButton(
                                                      onPressed: ()async {
                                                        Navigator.of(context)
                                                            .pop();
                                                            blocUsuarios.excluirUsuario(widget.pramideId,indexUsuarios);
                                                            blocUsuarios.carregaVazio(widget.pramideId);
                                                      },
                                                      child: Text('EXCLUIR'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  )),
                            );
                          },
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    //  Column(
    //   mainAxisSize: MainAxisSize.max,
    //   children: <Widget>[
    //     Container(
    //       height: 50,
    //     ),
    //     Expanded(child: _listaUsuarios(context))
    //   ],
    // );
  }

  Widget _listaUsuarios(BuildContext ctx) {
    return Container(
      // height: MediaQuery.of(ctx).size.height * 0.6,
      color: Colors.amber,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (ctx, usuIndex) {
          return Card(
            elevation: 3,
            child: Text('data'),
          );
        },
      ),
    );
  }
}
