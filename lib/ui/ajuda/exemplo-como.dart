import 'package:flutter/material.dart';

class Exemplo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TabPageSelector(
            color: Colors.blue.shade100,
            selectedColor: Colors.grey,
            indicatorSize: 15,
          ),
          Container(
            color: Colors.blue.shade50,
            height: 900,
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  //  color: Colors.indigo,
                  
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 60,
                  child: Text(
                    'Veja como exemplo a pirâmide abaixo:',
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset("assets/birt.png"),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 100,
                  child: Text(
                    'Nesse exemplo utilizaremos a Pirâmide de BIRD,' +
                        ' mas vocễ pode criar pirâmides personalizadas para qualquer problema multifatorial.',
                      textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  child: Text(
                    'A ideia é que a partir dessa pirâmide, seja possível evitar acidentes de trabalho em uma empresa.',
                       textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  //color: Colors.lightBlue,
                  height: 160,
                  child: Text(
                    'Em 1931 Frank Bird analisou 1.752.498 acidentes em 297 empresas com 1.750.000 trabalhadores. ' +
                        ' Com essa pesquisa Bird entendeu que a proporção das camadas da pirâmide seguem uma distribuição ' +
                        ' natural de acordo com a gravidade e impacto. ',
                       textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                   Container(
                  padding: EdgeInsets.all(15),
                  //color: Colors.lightBlue,
                  height: 100,
                  child: Text(
                    'Logo, com esses dados na mão é muito mais fácil atuar ' +
                        ' para prever e coibir oas acidentes graves do topo da pirâmide.',
                     textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
