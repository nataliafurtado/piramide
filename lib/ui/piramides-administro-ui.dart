import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/bloc/abas-bloc.dart';
import 'package:comportamentocoletivo/bloc/nova-piramide-bloc.dart';
import 'package:comportamentocoletivo/model/enums.dart';
import 'package:comportamentocoletivo/ui/aceitar-usuarios/aba-usuarios-ui.dart';
import 'package:comportamentocoletivo/ui/aceitar-usuarios/aceitar-usuarios-ui.dart';

import 'package:comportamentocoletivo/ui/configuracoes-piramide.dart';
import 'package:comportamentocoletivo/ui/informacoes-ui.dart';
import 'package:comportamentocoletivo/ui/nova-piramide-ui.dart';
import 'package:comportamentocoletivo/ui/novo-relato-ui.dart';
import 'package:comportamentocoletivo/ui/piramides-ui.dart';
import 'package:flutter/material.dart';

AbasBloc abasBloc = BlocProvider.getBloc<AbasBloc>();

class PiramideAdministro extends StatefulWidget {
  @override
  _PiramideAdministroState createState() => _PiramideAdministroState();
}

class _PiramideAdministroState extends State<PiramideAdministro> {
  @override
  void initState() {
    abasBloc = AbasBloc();
    abasBloc.carregaPiramide();
    //  print(abasBloc.piramidesController.value.length);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: abasBloc.piramidesFluxo,
      builder: (ctx, snap) {
        // print('tese');
        // print(abasBloc.piramidesController.value);
        // print(abasBloc.piramidesController.value.length);
        if (abasBloc.piramidesController.value == null) {
          return Center(
            child: Container(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (abasBloc.piramidesController.value.isEmpty) {
          return Center(
              child: Container(
                height: 150,
            padding: EdgeInsets.all(40),
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
                        ' CRIAR NOVA PIRÂMIDE ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        } else {
          return ListView.builder(
            itemCount: abasBloc.piramidesController.value.length,
            itemBuilder: (ctx, index) {
              return abasBloc.piramidesController.value.length == 0
                  ? Center(
                      child: Text('CRIE UMA PIRÂMIDE'),
                    )
                  : _piramideCard(index, context);
            },
          );
        }

        // switch (snap.connectionState) {
        //   case ConnectionState.none:
        //     return Text('Press button to start.');
        //   case ConnectionState.active:
        // //  return Text('Press button to ggggggggggg.');
        //   case ConnectionState.waiting:
        //     return ListView.builder(
        //       itemCount: blocHome.piramidesController.value.length,
        //       itemBuilder: (ctx, index) {
        //         return _piramideCard(index, context);
        //       },
        //     );
        //   case ConnectionState.done:
        //     if (snap.hasError) return Text('Error: ${snap.error}');
        //     return Text('Result: ${snap.data}');
        // }
        // return null; // unreachable

        // if (snap.connectionState == ConnectionState.done) {
        //   return ListView.builder(
        //     itemCount: blocHome.piramidesController.value.length,
        //     itemBuilder: (ctx, index) {
        //       return _piramideCard(index, context);
        //     },
        //   );
        // } else {
        //   return CircularProgressIndicator();
        // }
      },
    );
  }
}

double p = 0.4;

Widget _piramideCard(int index, BuildContext context) {
  return Card(
    color: Colors.blue.shade50,
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            // color: Colors.grey,
          height: 40,
          child: Align(
            alignment: Alignment(0, 0),
            child: Text(
              abasBloc.piramidesController.value[index].nome,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          //tamaho da card
          // color: Colors.cyanAccent,
          height: MediaQuery.of(context).size.width *
              0.14 *
              abasBloc
                  .piramidesController.value[index].camadasDaPiramide.length,
          //width: 300,
          alignment: Alignment.center,

          child: Container(
            //tamanho conteiner da piremide
            //   color: Colors.grey,
            height: MediaQuery.of(context).size.width *
                0.12 *
                abasBloc
                    .piramidesController.value[index].camadasDaPiramide.length,
            width: MediaQuery.of(context).size.width * 0.95,
            alignment: Alignment.center,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: abasBloc
                  .piramidesController.value[index].camadasDaPiramide.length,
              itemBuilder: (ctx, camadaIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        //  color: Colors.cyanAccent,
                        //alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width *
                            (0.12 * (camadaIndex + 1)),
                        child: CustomPaint(
                          painter: DrawTronco2(camadaIndex),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NovoRelato(
                                            piramide: abasBloc
                                                .piramidesController
                                                .value[index],
                                            camadaIndex: camadaIndex,
                                          )));
                            },
                            splashColor: Colors.deepOrange,
                            child: Container(
                              //  color: Colors.amber,
                              alignment: Alignment(0, 0.5),
                              child: Text(
                                   camadaIndex ==0?'1': camadaIndex ==1?'30': camadaIndex ==2?'300':camadaIndex ==3?'3000':camadaIndex ==4?'30000':'22',
                                // abasBloc.piramidesController.value[index]
                                //     .camadasDaPiramide[camadaIndex].total
                                //     .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        //  color: Colors.blue,
                        //alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * (0.35),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              abasBloc.piramidesController.value[index]
                                  .camadasDaPiramide[camadaIndex].nome,
                            )),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          //   ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(12),
              iconSize: 40,
              color: Colors.blueAccent,
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformacoesUi(
                              piramide:
                                  abasBloc.piramidesController.value[index],
                              usuarioAdm: true,
                            )));
                //  Navigator.pushNamed(context, Informacoes.route);
              },
            ),
            IconButton(
              padding: EdgeInsets.all(12),
              iconSize: 40,
              color: Colors.blueAccent,
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfiguracoesPiramide(
                              salvarAutomatico: true,
                              piramide:
                                  abasBloc.piramidesController.value[index],
                            )));
              },
            ),
            IconButton(
              padding: EdgeInsets.all(12),
              iconSize: 40,
              color: Colors.blueAccent,
              icon: Icon(Icons.directions_run),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AbaUsuariosUI(
                              pramideId: abasBloc
                                  .piramidesController.value[index].piramideId,
                            )));
              },
            )
          ],
        ),
        Container(
          height: 10,
        )
      ],
    ),
  );
}

class DrawTriangle extends CustomPainter {
  Paint _paint;

  DrawTriangle() {
    _paint = Paint()
      ..color = Colors.redAccent.shade200
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
