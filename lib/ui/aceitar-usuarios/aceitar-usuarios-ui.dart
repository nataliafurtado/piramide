import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/aceitar-usuario-bloc.dart';
import 'package:comportamentocoletivo/ui/aceitar-usuarios/usuario-info-ui.dart';
import 'package:flutter/material.dart';

AceitarUsuarioBloc aceitarUsuarioBloc =
    BlocProvider.getBloc<AceitarUsuarioBloc>();

class AceitarUsuario extends StatefulWidget {
  static const route = '/aceitar-usuario';

  final String pramideId;
  AceitarUsuario({this.pramideId});
  @override
  _AceitarUsuarioState createState() => _AceitarUsuarioState();
}

class _AceitarUsuarioState extends State<AceitarUsuario> {
  @override
  void initState() {
    aceitarUsuarioBloc = AceitarUsuarioBloc();
    aceitarUsuarioBloc.carregaPedidos(widget.pramideId);
    super.initState();
  }

//  final List<String> items = List<String>.generate(30, (i) => 'itans ${i + 1}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ACEITAR NOVOS RELATORES'),
        ),
        body: SingleChildScrollView(
          child: Column(
            //  mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('ARRASTE PARA A ESQUERDA PARA ACEITAR'),
              StreamBuilder(
                stream: aceitarUsuarioBloc.pedidosFluxo,
                initialData: [],
                builder: (ctx, snap) {
                  return snap.data.length == 0
                      ? Center(
                          child: Text('Não existem novos pedidos'),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data.length,
                          itemBuilder: (cox, pedidoIndex) {
                            return Dismissible(
                              background: Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.not_interested,
                                    ),
                                    Icon(
                                      Icons.thumb_up,
                                    )
                                  ],
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 15, left: 15),
                              ),
                              key: ValueKey(snap.data[pedidoIndex].pedidoId),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  aceitarUsuarioBloc
                                      .aceitarUsuario(pedidoIndex);
                                  Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('ACEITO'),
                                    ),
                                  );
                                } else {
                                  aceitarUsuarioBloc
                                      .recusarUsuario(pedidoIndex);
                                  Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text('RECUSADO'),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: InkWell(
                                  splashColor: Colors.orange,
                                  onTap: () {
                                    //  Navigator.push(
                                    //                               context,
                                    //                               MaterialPageRoute(
                                    //                                   builder: (context) => UsuarioInfo(
                                    //                                         usuarioId: snap.data.usuarioId ,
                                    //                                       )));
                                  },
                                  child: Container(
                                    height: 60,
                                    child: Card(
                                      elevation: 5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 15,
                                          ),
                                          Icon(Icons.perm_identity),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(snap.data[pedidoIndex].nome)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                  ;
                },
              ),
            ],
          ),
        )

        //   Text(aceitarUsuarioBloc.pedidosController.value.length==0 ? 'ZERO' : aceitarUsuarioBloc.pedidosController.value[0].nome),
        );
  }
}
