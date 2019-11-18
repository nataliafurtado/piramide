import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:comportamentocoletivo/bloc/nova-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/ui/ajuda/ajuda-ui.dart';
import 'package:comportamentocoletivo/ui/nova-piramide-ui.dart';
import 'package:comportamentocoletivo/ui/procurar-piramide-ui.dart';
import 'package:flutter/material.dart';

NovaPiramideBLoc bloc = BlocProvider.getBloc<NovaPiramideBLoc>();

class Piramides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blueAccent.shade50,
            height: 130,
            child: Center(
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  elevation: 10,
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.pushNamed(context, ProcurarPiramide.route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.blueAccent.shade700,
                      ),

                      Container(
                      //  width: MediaQuery.of(context).size.width*0.5,
                        child: Text(
                          'PROCURAR PIRÂMIDE',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: <Widget>[
                      //     Text(
                      //       'PEDIR PERMISSÃO PODER RELATAR EM UMA PIRÂMIDE JA EXISTENTE',
                      //       style: TextStyle(fontSize: 15),
                      //     ),

                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
           color: Colors.blueAccent.shade50,
            height: 130,
            child: Center(
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  elevation: 10,
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    bloc = NovaPiramideBLoc();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NovaPiramide(
                                modelo: piramidesModeloEnum.generica)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        Icons.change_history,
                        size: 40,
                        color: Colors.blueAccent.shade700,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'CRIAR NOVA PIRÂMIDE ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.black, height: .5),
          Container(
          color: Colors.blueAccent.shade50,
            height: 60,
            child: Align(
              alignment: Alignment(-0.6, 1),
              child: Text('UTILIZAR MODELOS: ', style: TextStyle(fontSize: 15)),
            ),
          ),
          Container(
            color: Colors.blueAccent.shade50,
            height: 130,
            child: Align(
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  //color: Colors.blue.shade100,
                  elevation: 10,
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    bloc = NovaPiramideBLoc();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NovaPiramide(
                                modelo: piramidesModeloEnum.birt)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.local_hospital,
                        size: 40,
                        color: Colors.redAccent.shade200,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'PIRÂMIDE DE BIRD ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blueAccent.shade50,
            height: 130,
            child: Center(
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  elevation: 10,
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    bloc = NovaPiramideBLoc();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NovaPiramide(
                                modelo: piramidesModeloEnum.lgbtfobia)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.looks,
                        size: 40,
                        color: Colors.blueAccent.shade700,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'PIRÂMIDE DE LGBTFOBIA ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(color: Colors.black, height: .5),
          Container(
            color: Colors.grey.shade300,
            height: 100,
            child: Center(
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  color: Colors.blue.shade200,
                  //color: Colors.yellowAccent.shade400,
                  elevation: 10,
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    Navigator.pushNamed(context, AjudaUi.route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.help_outline,
                        size: 35,
                        color: Colors.blue.shade900,
                       // color: Colors.grey.shade700,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'COMO FUNCIONA? ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
