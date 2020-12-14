class Grupo {
  int idgrupo;
  String grupo;

  Grupo({this.idgrupo, this.grupo});

  Map toJson() => {'idgrupo': this.idgrupo, 'grupo': this.grupo};

  factory Grupo.fromJson(Map<String, dynamic> parsedJson) {
    return Grupo(
      idgrupo: parsedJson['idgrupo'] as int,
      grupo: parsedJson['grupo'] as String,
    );
  }
}
