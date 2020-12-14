class Conjunto {
  int idconjunto;
  String conjunto;

  Conjunto({this.idconjunto, this.conjunto});

  Map toJson() => {'idconjunto': this.idconjunto, 'conjunto': this.conjunto};

  factory Conjunto.fromJson(Map<String, dynamic> parsedJson) {
    return Conjunto(
      idconjunto: parsedJson['idconjunto'] as int,
      conjunto: parsedJson['conjunto'] as String,
    );
  }
}
