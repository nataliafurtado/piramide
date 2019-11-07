import 'package:flutter/material.dart';

class PrecosUi extends StatefulWidget {
  static const route = '/precos';
  @override
  _PrecosUiState createState() => _PrecosUiState();
}

class _PrecosUiState extends State<PrecosUi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Política de Preços'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.change_history,
                  color: Colors.pink,
                  size: 50.0,
                ),
                Container(
                  height: 20,
                ),

                Table(
                  border: TableBorder.all(width: 1,color: Colors.black54),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Center(
                          child: Text(
                        'PIRÂMIDES',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                      Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('USUÁRIO POR PIRÂMIDE POR MÊS',     style: TextStyle(
                                  //  color: Colors.black,
                                    fontWeight: FontWeight.bold),))),
                      Center(child: Text('POR REALATO',     style: TextStyle(
                                    fontWeight: FontWeight.bold),)),
                    ]),
                    TableRow(children: [
                      Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'PÚBLICA',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))),
                      Center(
                          child: Text(
                        'GRÁTIS',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
                      Center(
                          child: Text(
                        'GRÁTIS',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
                    ]),
                    TableRow(children: [
                      Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('PRIVADA',     style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),))),
                      Center(child: Text('RS 0,25',     style: TextStyle(
                                    fontWeight: FontWeight.bold),)),
                      Center(child: Text('RS 0,10',     style: TextStyle(
                                    fontWeight: FontWeight.bold),)),
                    ])
                  ],
                )
,
                Text(
                    ' * Pirâmides públicas os dados ficam abertos ao público.'),
           
    
                 Text(' * Pirâmides sem créditos não poderam abrir novos relatos.')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
