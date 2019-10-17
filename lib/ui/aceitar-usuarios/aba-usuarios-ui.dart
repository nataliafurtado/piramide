import 'package:comportamentocoletivo/ui/aceitar-usuarios/aceitar-usuarios-ui.dart';
import 'package:comportamentocoletivo/ui/aceitar-usuarios/usuarios-ui.dart';
import 'package:flutter/material.dart';

class AbaUsuariosUI extends StatefulWidget {
  final String pramideId;
  AbaUsuariosUI({this.pramideId});
  static const route = '/aba-usuarios';

  @override
  _AbaUsuariosUIState createState() => _AbaUsuariosUIState();
}

class _AbaUsuariosUIState extends State<AbaUsuariosUI> {
  String titulo = 'ACEITAR NOVOS USUÁRIOS';
  String _tituloApp(int pag) {
    if (pag == 1) {
      return 'USUÁRIOS';
    } else if (pag == 0) {
      return 'ACEITAR NOVOS USUÁRIOS';
    }

    return 'USUÁRIOS';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // actions: <Widget>[
          //   PopupMenuButton<OrderOptions>(
          //     itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
          //       const PopupMenuItem<OrderOptions>(
          //         child: Text("Como funciona ?"),
          //         value: OrderOptions.comofunciona,
          //       ),
          //       const PopupMenuItem<OrderOptions>(
          //         child: Text("Sair"),
          //         value: OrderOptions.logout,
          //       ),
          //     ],
          //     onSelected: _orderList,
          //   ),
          // ],
          title: Text(titulo),
          bottom: TabBar(
            onTap: (indexx) {
              setState(() {
                titulo = _tituloApp(indexx);
              });
            
            },
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person_add)),
              Tab(icon: Icon(Icons.person)),
              // Tab(icon: Icon(Icons.details)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AceitarUsuario(
              pramideId: widget.pramideId,
            ),
            UsuariosUi(
              pramideId: widget.pramideId,
            ),
          ],
        ),
      ),
    );
  }
}
