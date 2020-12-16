class SituacaoBem {
  int idsituacao;
  String situacao;

  SituacaoBem({this.idsituacao, this.situacao});

  Map toJson() => {'idsituacao': this.idsituacao, 'situacao': this.situacao};

  factory SituacaoBem.fromJson(Map<String, dynamic> parsedJson) {
    return SituacaoBem(
      idsituacao: parsedJson['idsituacao'] as int,
      situacao: parsedJson['situacao'] as String,
    );
  }
}
