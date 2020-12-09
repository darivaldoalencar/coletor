class Inventario {
  int placa;
  String centrocusto;
  String desbem;
  int idclassebem;
  String classe;

  int idgrupo;
  int idgrupoold;
  String grupo;

  int idresponsavel;
  int idresponsavelold;
  String responsavel;

  int idlocalizacao;
  int idlocalizacaoold;
  String localizacao;

  int idconjunto;
  int idconjuntoold;
  String conjunto;

  String flgaltera;

  Inventario(
      {this.placa,
      this.centrocusto,
      this.desbem,
      this.idclassebem,
      this.classe,
      this.idconjunto,
      this.idconjuntoold,
      this.conjunto,
      this.idlocalizacao,
      this.idlocalizacaoold,
      this.localizacao,
      this.idgrupo,
      this.idgrupoold,
      this.grupo,
      this.idresponsavel,
      this.idresponsavelold,
      this.responsavel,
      this.flgaltera});

  factory Inventario.fromJson(Map<String, dynamic> parsedJson) {
    return Inventario(
        placa: parsedJson['placa'] as int,
        centrocusto: parsedJson['codcentrocusto'] as String,
        desbem: parsedJson['desbem'] as String,
        idclassebem: parsedJson['idclassebem'] as int,
        classe: parsedJson['classe'] as String,
        idconjunto: parsedJson['idconjunto'] as int,
        idconjuntoold: parsedJson['idconjuntoold'] as int,
        conjunto: parsedJson['conjunto'] as String,
        idlocalizacao: parsedJson['idlocalizacao'] as int,
        idlocalizacaoold: parsedJson['idlocalizacaoold'] as int,
        localizacao: parsedJson['localizacao'] as String,
        idgrupo: parsedJson['idgrupo'] as int,
        idgrupoold: parsedJson['idgrupoold'] as int,
        grupo: parsedJson['grupo'] as String,
        idresponsavel: parsedJson['idresponsavel'] as int,
        idresponsavelold: parsedJson['idresponsavelold'] as int,
        responsavel: parsedJson['responsavel'] as String,
        flgaltera: parsedJson['flgaltera'] as String);
  }
}
