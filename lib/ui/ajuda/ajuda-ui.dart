import 'package:comportamentocoletivo/ui/ajuda/exemplo-como.dart';
import 'package:comportamentocoletivo/ui/ajuda/instrucao1.dart';
import 'package:comportamentocoletivo/ui/ajuda/porque.dart';
import 'package:flutter/material.dart';

class AjudaUi extends StatefulWidget {
   static const route = '/ajuda';
  @override
  _AjudaUiState createState() => _AjudaUiState();
}

class _AjudaUiState extends State<AjudaUi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('COMO FUNCIONA ?'),
        ),
        body: TabBarView(children: <Widget>[
          Porque(),
          Exemplo(),
          Instrucao1()
        ],),
      ) ,

    );
  }
}
