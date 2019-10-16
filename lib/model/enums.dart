enum perguntasEnum { quem, oque, quando, onde, como, porque }

enum pedidosEnum { aberto, aceito, negado }

enum piramidesModeloEnum { generica, birt, lgbtfobia }

class PerguntasEnumConverter {
  // final perguntasEnum;
  // EnumConverter(this.perguntasEnum);

  String converter(perguntasEnum hh) {
    // print(hh);
    // print('hh');
    if (hh == perguntasEnum.quem) {
      return "QUEM?";
    } else if (hh == perguntasEnum.oque) {
      return "O QUE?";
    } else if (hh == perguntasEnum.quando) {
      return "QUANDO?";
    } else if (hh == perguntasEnum.onde) {
      return "ONDE?";
    } else if (hh == perguntasEnum.como) {
      return "COMO?";
    } else if (hh == perguntasEnum.porque) {
      return "POR QUE?";
    } else if (hh == null) {
      return 'null';
    }

    return 'NA';
  }

  perguntasEnum enumConverter(String enumString) {
    if (enumString == 'perguntasEnum.quem') {
      return perguntasEnum.quem;
    } else if (enumString == 'perguntasEnum.oque') {
      return perguntasEnum.oque;
    } else if (enumString == 'perguntasEnum.quando') {
      return perguntasEnum.quando;
    } else if (enumString == 'perguntasEnum.onde') {
      return perguntasEnum.onde;
    } else if (enumString == 'perguntasEnum.como') {
      return perguntasEnum.como;
    } else if (enumString == 'perguntasEnum.porque') {
      return perguntasEnum.porque;
    }

    return perguntasEnum.como;
  }
}


class PedidosEnumConverter {
  // final perguntasEnum;
  // EnumConverter(this.perguntasEnum);

  String converter(pedidosEnum hh) {
    // print(hh);
    // print('hh');
    if (hh == pedidosEnum.aberto) {
      return "ABERTO";
    } else if (hh == pedidosEnum.aceito) {
      return "ACEITO";
    } else if (hh == pedidosEnum.negado) {
      return "NEGADO";
    } 

    return 'NA';
  }

  pedidosEnum enumConverter(String enumString) {
    if (enumString == 'pedidosEnum.aberto') {
      return pedidosEnum.aberto;
    } else if (enumString == 'pedidosEnum.aceito') {
      return pedidosEnum.aceito;
    } else if (enumString == 'pedidosEnum.negado') {
      return pedidosEnum.negado;
    } 

    return pedidosEnum.negado;
  }
}






class PiramidesEnumConverter {
  // final perguntasEnum;
  // EnumConverter(this.perguntasEnum);

  String converter(piramidesModeloEnum hh) {
    // print(hh);
    // print('hh');
    if (hh == piramidesModeloEnum.generica) {
      return "GENÉRICA";
    } else if (hh == piramidesModeloEnum.birt) {
      return "BIRT";
    } else if (hh == piramidesModeloEnum.lgbtfobia) {
      return "LGBTFOBIA";
    } 

    return 'NA';
  }

  piramidesModeloEnum enumConverter(String enumString) {
    if (enumString == 'piramidesModeloEnum.generica') {
      return piramidesModeloEnum.generica;
    } else if (enumString == 'piramidesModeloEnum.birt') {
      return piramidesModeloEnum.birt;
    } else if (enumString == 'piramidesModeloEnum.lgbtfobia') {
      return piramidesModeloEnum.lgbtfobia;
    } 

    return piramidesModeloEnum.generica;
  }
}
