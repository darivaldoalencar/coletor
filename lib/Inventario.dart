class Inventario {
  int idinventariobens;
  List<InventarioItens> items;

  Inventario({this.idinventariobens, this.items});

  Map toJson() =>
      {'idinventariobens': this.idinventariobens, 'items': this.items};

  factory Inventario.fromJson(Map<String, dynamic> parsedJson) {
    var lista = parsedJson['items'] as List;
    List<InventarioItens> items =
        lista.map((p) => InventarioItens.fromJson(p)).toList();

    return Inventario(
        idinventariobens: parsedJson['idinventariobens'] as int, items: items);
  }
}

class InventarioItens {
  int placa;
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

  int iibflgsitfisica;

  InventarioItens(
      {this.placa,
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
      this.flgaltera,
      this.iibflgsitfisica});

  Map toJson() => {
        'placa': this.placa,
        'desbem': this.desbem,
        'idclassebem': this.idclassebem,
        'classe': this.classe,
        'idconjunto': this.idconjunto,
        'idconjuntoold': this.idconjuntoold,
        'conjunto': this.conjunto,
        'idlocalizacao': this.idlocalizacao,
        'idlocalizacaoold': this.idlocalizacaoold,
        'localizacao': this.localizacao,
        'idgrupo': this.idgrupo,
        'idgrupoold': this.idgrupoold,
        'grupo': this.grupo,
        'idresponsavel': this.idresponsavel,
        'idresponsavelold': this.idresponsavelold,
        'responsavel': this.responsavel,
        'flgaltera': this.flgaltera,
        'iibflgsitfisica': this.iibflgsitfisica
      };

  factory InventarioItens.fromJson(Map<String, dynamic> parsedJson) {
    return InventarioItens(
        placa: parsedJson['placa'] as int,
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
        flgaltera: parsedJson['flgaltera'] as String,
        iibflgsitfisica: parsedJson['iibflgsitfisica'] as int);
  }
}
