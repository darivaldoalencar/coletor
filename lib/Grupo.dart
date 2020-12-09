class Grupo {
  String placatombamento;

  String idgrupo;
  String nome;

  String idresp;
  String nomeresp;

  Grupo({this.idgrupo, this.nome});

  factory Grupo.fromJson(Map<String, dynamic> parsedJson) {
    return Grupo(
        idgrupo: parsedJson['idgrupo'] as String,
        nome: parsedJson['nome'] as String);
  }
}
