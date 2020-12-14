class Responsavel {
  int idresponsavel;
  String responsavel;

  Responsavel({this.idresponsavel, this.responsavel});

  Map toJson() =>
      {'idresponsavel': this.idresponsavel, 'responsavel': this.responsavel};

  factory Responsavel.fromJson(Map<String, dynamic> parsedJson) {
    return Responsavel(
      idresponsavel: parsedJson['idresponsavel'] as int,
      responsavel: parsedJson['responsavel'] as String,
    );
  }
}
