import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:flutter/material.dart';

class ConfiguracoesPiramide extends StatelessWidget {
  final Piramide piramide;

  ConfiguracoesPiramide({this.piramide});
  static const route = '/configuracoes-piramide';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dd'),
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
                  value: false,
                  onChanged: (d) {},
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
