import 'package:flutter/material.dart';

class Instrucao1 extends StatelessWidget {
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
            height: 1500,
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  //  color: Colors.indigo,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 80,
                  child: Text(
                    'Crie uma piramide personalizada ou utilize os modelos prontos:',
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
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Image.asset("assets/lgbt.png"),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Divider(color: Colors.blueGrey.shade500, height: .4)),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 90,
                  child: Text(
                    'Se a pirâmide for criada privada é preciso que os novos usuários peçam permissão' +
                        'para poderem utiliza-la criando novos relatos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset("assets/participar.png"),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Divider(color: Colors.blueGrey.shade500, height: .4)),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 60,
                  child: Text(
                    'O usuário Administrador deve aceitar a permissão',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset("assets/aceitar.png"),
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Divider(color: Colors.blueGrey.shade500, height: .4)),
                Container(
                  padding: EdgeInsets.all(15),
                  //color: Colors.lightBlue,
                  height: 60,
                  child: Text(
                    'Agora Usuário pode criar novos relatos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset("assets/novo-relato.png"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
