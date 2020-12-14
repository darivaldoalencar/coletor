class Localizacao {
  int idlocalizacao;
  String localizacao;

  Localizacao({this.idlocalizacao, this.localizacao});

  Map toJson() =>
      {'idlocalizacao': this.idlocalizacao, 'localizacao': this.localizacao};

  factory Localizacao.fromJson(Map<String, dynamic> parsedJson) {
    return Localizacao(
      idlocalizacao: parsedJson['idlocalizacao'] as int,
      localizacao: parsedJson['localizacao'] as String,
    );
  }
}
