import 'package:comportamentocoletivo/ui/aceitar-usuarios/aceitar-usuarios-ui.dart';
import 'package:flutter/material.dart';

class UsuarioInfo extends StatefulWidget {
  static const route = '/usuario-info';

  final String usuarioId;
  UsuarioInfo({this.usuarioId});
  @override
  _UsuarioInfoState createState() => _UsuarioInfoState();
}

class _UsuarioInfoState extends State<UsuarioInfo> {
  @override
  void initState() {
   aceitarUsuarioBloc.carregaUsuario(widget.usuarioId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
