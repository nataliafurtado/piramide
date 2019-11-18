import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:comportamentocoletivo/aux/draw-tronco.dart';
import 'package:comportamentocoletivo/bloc/abas-bloc.dart';
import 'package:comportamentocoletivo/ui/abas-ui.dart';

import 'package:comportamentocoletivo/ui/informacoes-ui.dart';
import 'package:comportamentocoletivo/ui/novo-relato-ui.dart';
import 'package:comportamentocoletivo/ui/procurar-piramide-ui.dart';
import 'package:flutter/material.dart';

AbasBloc abasBloc = BlocProvider.getBloc<AbasBloc>();

class PiramidePodeRelatar extends StatefulWidget {
  final bool novoUsuario;

  PiramidePodeRelatar({this.novoUsuario});
  @override
  _PiramidePodeRelatarState createState() => _PiramidePodeRelatarState();
}

class _PiramidePodeRelatarState extends State<PiramidePodeRelatar> {
  double tamanho = 0.0;


  @override
  void initState() {
    abasBloc = AbasBloc();
    abasBloc.carregaPiramidePodeRelatar();

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: abasBloc.piramidesPodeRelatarFluxo,
      builder: (ctx, snap) {
        if (abasBloc.piramidesPodeRelatarController.value == null) {
          return Center(
            child: Container(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (abasBloc.piramidesPodeRelatarController.value.isEmpty) {
          return Center(
              child: Container(
            height: 150,
            padding: EdgeInsets.all(35),
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
                    size: 50,
                    color: Colors.blueAccent.shade700,
                  ),

                  Container(
                    width: 200,
                    child: Text(
                      'PEDIR PERMISSÃO A UMA PIRÂMIDE JÁ EXISTENTE',
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
          ));
        } else {
          if (
            widget.novoUsuario != null && widget.novoUsuario ==
             true) {
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  tamanho = 45.0;
                });
              }
            });
          }
          return Column(
            children: <Widget>[
              Visibility(
                visible: widget.novoUsuario != null
                    ? widget.novoUsuario
                    : false,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Align(
                    alignment: Alignment(-1, 0),
                                      child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      decoration: BoxDecoration(
                           color: Colors.blue.shade50,
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius:
                          // BorderRadius.all(Radius.circular(10))
                           BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )
                           ),
                      // curve: Curves.bounceIn,
                      height: tamanho,
                      // color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('  APERTE NA PIRÂMIDE PARA CRIAR RELATOS'),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            onPressed: () {
                           
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AbaUi(aba: 1, novoUsuario: false, mostraPiramideAdm: false,  )));
                             
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                // height: 700,
                child: ListView.builder(
                  itemCount:
                      abasBloc.piramidesPodeRelatarController.value.length,
                  itemBuilder: (ctx, index) {
                    return _piramideCard(index, context);
                  },
                ),
              )
            ],
          );
        }
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
          //   color: Colors.grey,
          height: 40,
          child: Align(
            alignment: Alignment(0, 0),
            child: Text(
              abasBloc.piramidesPodeRelatarController.value[index].nome,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          //tamaho da card
          // color: Colors.cyanAccent,
          height: MediaQuery.of(context).size.height *
              0.08 *
              abasBloc.piramidesPodeRelatarController.value[index]
                  .camadasDaPiramide.length,
          //width: 300,
          alignment: Alignment.center,

          child: Container(
            //tamanho conteiner da piremide
            //   color: Colors.grey,
            height: MediaQuery.of(context).size.width *
                0.12 *
                abasBloc.piramidesPodeRelatarController.value[index]
                    .camadasDaPiramide.length,
            width: MediaQuery.of(context).size.width * 0.95,
            alignment: Alignment.center,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: abasBloc.piramidesPodeRelatarController.value[index]
                  .camadasDaPiramide.length,
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
                                                .piramidesPodeRelatarController
                                                .value[index],
                                            camadaIndex: camadaIndex,
                                          )));
                            },
                            splashColor: Colors.deepOrange,
                            child: Container(
                              //  color: Colors.amber,
                              alignment: Alignment(0, 0.5),
                              child: Text(
                                abasBloc
                                    .piramidesPodeRelatarController
                                    .value[index]
                                    .camadasDaPiramide[camadaIndex]
                                    .total
                                    .toString(),
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
                        height: MediaQuery.of(context).size.width * 0.12,
                        width: MediaQuery.of(context).size.width * (0.35),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              abasBloc
                                  .piramidesPodeRelatarController
                                  .value[index]
                                  .camadasDaPiramide[camadaIndex]
                                  .nome,
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
                              piramide: abasBloc
                                  .piramidesPodeRelatarController.value[index],
                              usuarioAdm: false,
                              podeDeixarSeguir: true,
                            )));
              },
            ),
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
