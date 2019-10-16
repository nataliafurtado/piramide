import 'package:comportamentocoletivo/model/camada-info.dart';

class Periodo {
  int totalTodasAsCamadas;
  String dataInicio;
  String dataFim;
  bool geral;
 

  List<CamadaInfo> camadasInfo;

  Periodo({
    this.totalTodasAsCamadas,
    this.dataInicio,
    this.dataFim,
    this.geral,
    this.camadasInfo
  });

  // Map toMap() {
  //   Map<String, dynamic> map = {
  //     'totalTodasAsCamadas': totalTodasAsCamadas,
  //     'dataInicio': dataInicio,
  //     'dataFim': dataFim,
  //     'geral': geral,
  //   };

  //   return map;
  // }

  // Periodo.fromMap(Map map) {
  //   totalTodasAsCamadas = map['totalTodasAsCamadas'];
  //   dataInicio = map['dataInicio'];
  //   dataFim = map['dataFim'];
  //   geral = map['geral'];
  // }
}
