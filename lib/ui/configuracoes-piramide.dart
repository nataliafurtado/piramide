import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPiramide extends StatefulWidget {
  final Piramide piramide;

  ConfiguracoesPiramide({this.piramide});
  static const route = '/configuracoes-piramide';

  @override
  _ConfiguracoesPiramideState createState() => _ConfiguracoesPiramideState();
}

class _ConfiguracoesPiramideState extends State<ConfiguracoesPiramide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONFIGURAÇÕES'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('PÚBLICA'),
                Checkbox(
                  value: widget.piramide.publica,
                  onChanged: (valor) {
                    print(valor);
                    setState(() {
                      widget.piramide.publica=valor;
                    });
                  },
                ),
              ],
            ),
            // Container(
            //   height: 30,
            //   child: Center(
            //     child: Text('Lista Usuários'),
            //   ),
            // ),
       
          ],
        ),
      ),
    );
  }
}
