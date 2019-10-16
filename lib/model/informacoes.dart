import 'package:comportamentocoletivo/model/camada-info.dart';
import 'package:comportamentocoletivo/model/pergunta-relato.dart';
import 'package:comportamentocoletivo/model/periodo.dart';

class Informacoes {
  String piramideId;
  // String dataFim;
  // int totalPiramide;
  int nperiodos;
  int numeroCamadas;
  String informacoesId;
  List<Periodo> periodos;

  Informacoes({
    this.piramideId,
    this.periodos,
    // this.dataFim,
    this.numeroCamadas,
    this.nperiodos,
     this.informacoesId
  });

  Map toMap() {
    Map<String, dynamic> map = {
      'piramideId': piramideId,
      'numeroCamadas': numeroCamadas,
      'nperiodos': nperiodos,
      
      //    'usuarioInformacoesuId': usuarioInformacoesuId,
      //  'ncamada': ncamada,
    };
    if (periodos == null) {
      periodos = [];
    }
    if (periodos.isNotEmpty) {
      for (var i = 0; i < periodos.length; i++) {
        if (i == 0) {
          Map<String, dynamic> geralMap = {
            'totalGeral': periodos[i].totalTodasAsCamadas,
          };
          for (var ii = 0; ii < periodos[i].camadasInfo.length; ii++) {
            geralMap['totalCamada${periodos[i].camadasInfo[ii].camada}'] =
                periodos[i].camadasInfo[ii].totalCamada;
          }
          map.addAll({'dadosGeral': geralMap});
        } else {
          Map<String, dynamic> camadasMap = {
            'total': periodos[i].totalTodasAsCamadas,
            'dataInicio': periodos[i].dataInicio,
            'dataFim': periodos[i].dataFim
          };
          for (var ii = 0; ii < periodos[i].camadasInfo.length; ii++) {
            camadasMap['totalCamada${periodos[i].camadasInfo[ii].camada}'] =
                periodos[i].camadasInfo[ii].totalCamada;
          }
          map.addAll({'periodo$i': camadasMap});
        }
      }
    }
    return map;
  }

  Informacoes.fromMap(Map map,String informacoesIdPassada) {
    piramideId = map['piramideId'];
     numeroCamadas = map['numeroCamadas'];
    nperiodos = map['nperiodos'];
    informacoesId=informacoesIdPassada;
    // usuarioInformacoesuId = map['usuarioInformacoesuId'];
    if (periodos == null) {
      periodos = [];
    }

   // print('nperiodos'+map['nperiodos'].toString());
    for (var iff = 0; iff < map['nperiodos']; iff++) {
      if (iff == 0) {
        Periodo c = Periodo(
          geral: true,
            totalTodasAsCamadas: map['dadosGeral']['totalGeral'],
            camadasInfo: []);
        for (var iii = 0; iii < map['numeroCamadas']; iii++) {
          c.camadasInfo.add(CamadaInfo(
              totalCamada: map['dadosGeral']['totalCamada$iii'], camada: iii));
        }
         periodos.add(c);
      } else {
//  DateTime t = DateTime.parse(map['periodo$iff']['dataInicio']);
//         String formattedDateInicio = DateFormat('yyyy-MM-dd kk:mm').format(t);
//         DateTime tt = DateTime.parse(map['periodo$iff']['dataFim']);
//         String formattedDateFim = DateFormat('yyyy-MM-dd kk:mm').format(tt);
        Periodo c = Periodo(
          geral: false,
            totalTodasAsCamadas: map['periodo$iff']['total'],
            dataInicio: map['periodo$iff']['dataInicio'],
            dataFim: map['periodo$iff']['dataFim'],
            camadasInfo: []);
        for (var iii = 0; iii < map['numeroCamadas']; iii++) {
          c.camadasInfo.add(CamadaInfo(
              totalCamada: map['periodo$iff']['totalCamada$iii'], camada: iii));
        }
    

        periodos.add(c);
      }
    }
  }
}
