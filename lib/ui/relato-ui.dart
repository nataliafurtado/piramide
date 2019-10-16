import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/model/piramide.dart';
import 'package:comportamentocoletivo/model/relato.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoUi extends StatefulWidget {
  static const route = '/relato';
  final Relato relato;
  final Piramide piramide;
  RelatoUi({this.relato, this.piramide});
  @override
  _RelatoUiState createState() => _RelatoUiState();
}

class _RelatoUiState extends State<RelatoUi> {
@override
  void initState() {   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RELATO'),
      ),
      body: SingleChildScrollView(
              child: Center(
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(15),
                                      child: Row(                    
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * (0.12 * (2 + 1)),
                child: CustomPaint(
                    painter: DrawTronco(widget.relato.numeroCamada,
                        widget.piramide.camadasDaPiramide.length),
                    child: Container(
                      //  color: Colors.amber,
                      alignment: Alignment(0, 0.5),
                    ),
                ),
              ),
              Text(widget.piramide.camadasDaPiramide[widget.relato.numeroCamada].nome)
            ],
          ),
                  ),

          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('PIRAMIDE : '),
                    Container(
                      width: 10,
                    ),
                    Text(widget.piramide.nome),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('USUÁRIO: '),
                    Container(
                      width: 10,
                    ),
                    Text(widget.relato.usarioNome),
                  ],
                ),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('DATA CRIAÇÂO: '),
                    Container(
                      width: 10,
                    ),
                    Text(_formataData(widget.relato.datacriacao)),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Container(
                   height:
                  // //double.infinity,
                    500 * widget.relato.perguntasRelato.length.toDouble(),
                  child: ListView.builder(
                    itemCount: widget.relato.perguntasRelato.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 5,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(PerguntasEnumConverter().converter(widget
                                .relato.perguntasRelato[index].perguntaEnum)),
                            Text(
                              widget.relato.perguntasRelato[index].resposta ==
                                      null
                                  ? widget.relato.datacriacao
                                  : widget.relato.perguntasRelato[index].resposta,
                            ),

                            // Container(
                            //   height: 30,
                            // )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formataData(String data) {
    if (data == null) {
      return '   ABERTA   ';
    }
    DateTime t = DateTime.parse(data);
    String formattedDate = DateFormat('dd/MM/yyyy').format(t);
    //  print('11111');
    //  print(formattedDate);
    return formattedDate;
  }
}
//  Navigator.of(context).pop();