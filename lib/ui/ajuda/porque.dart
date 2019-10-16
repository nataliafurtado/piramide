import 'package:flutter/material.dart';

class Porque extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TabPageSelector(
            color: Colors.blueGrey.shade100,
            selectedColor: Colors.grey,
            indicatorSize: 15,
          ),
          Container(
            color: Colors.blueGrey.shade50,
            height: 600,
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  //  color: Colors.indigo,
                  child: Center(
                    // child: Text(
                    //   'POR QUE ?',
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 100,
                  child: Text(
                    'Para gerenciar comportamentos que que ocorrem numa proporção de pirâmide  .',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),

                //  Container(
                //   padding: EdgeInsets.all(30),
                //   height: 100,
                //   child: Text('Para gerenciar eventos que ocorrem numa proporção de pirâmide.'),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Image.asset("assets/exemplo.png"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 60,
                  child: Text(
                    'Crie pirâmides personalizadas ou utilize modelos prontos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 100,
                  child: Text(
                    'Ideal para empresas e pesquisas de comportamento coletivo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
