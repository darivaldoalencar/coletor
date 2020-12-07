import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'Grupo.dart';
//import 'package:json_annotation/json_annotation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Inventário'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msgErro = "";
  bool loading = true;

  static List<Grupo> grupos = new List<Grupo>();
  AutoCompleteTextField searchTextFieldGrupo;
  GlobalKey<AutoCompleteTextFieldState<Grupo>> keyGrupo = new GlobalKey();

  final txtPlaca = TextEditingController();
  final txtConjunto = TextEditingController();
  final txtLocalizacao = TextEditingController();
  final txtResponsavel = TextEditingController();
  final txtGrupo = TextEditingController();

  String idConjunto;
  String idLocalizacao;
  String idGrupo;
  String idResponsavel;

  String idConjuntoOld;
  String idLocalizacaoold;
  String idGrupoold;
  String idResponsavelold;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool manipularEstoque() {
    setState(() {
      if (this.txtPlaca.text.length <= 0) {
        this.msgErro = "Informe a placa.";
        return false;
      } else if (this.txtConjunto.text.length <= 0) {
        this.msgErro = "Informe o conjunto.";
        return false;
      } else if (this.txtLocalizacao.text.length <= 0) {
        this.msgErro = "Informe a localização.";
        return false;
      } else if (this.txtGrupo.text.length <= 0) {
        this.msgErro = "Informe o grupo.";
        return false;
      } else if (this.txtResponsavel.text.length <= 0) {
        this.msgErro = "Informe o responsável.";
        return false;
      } else {
        this.msgErro = "Item coletado.";
        return true;
      }
    });
  }

  Future<String> get _localPath async {
    String path = "/storage/emulated/0/Download";

    final directory = Directory(path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bd.json');
  }

  Future<File> get _localFileGrupos async {
    final path = await _localPath;
    return File('$path/grupos.json');
  }

  Future<String> readJson() async {
    try {
      final file = await _localFile;
      bool _fileExists = await file.exists();

      if (_fileExists) {
        String contents = await file.readAsString();

        //Map<String, dynamic> resp = jsonDecode(contents);
        //print('nome: ${resp['name']}!');
        //print('e-mail: ${resp['email']}.');

        return contents;
      } else {
        return "";
      }
    } catch (e) {
      print('Descrição do Erro: $e');
      return "ERRO";
    }
  }

  void limparForm() {
    setState(() {
      this.txtPlaca.text = this.txtConjunto.text = this.txtGrupo.text =
          this.txtLocalizacao.text = this.txtResponsavel.text = "";

      this.idConjunto =
          this.idLocalizacao = this.idGrupo = this.idResponsavel = "";

      this.idConjuntoOld =
          this.idLocalizacaoold = this.idGrupoold = this.idResponsavelold = "";
    });
  }

  void getGrupos() async {
    try {
      final file = await _localFileGrupos;
      bool _fileExists = await file.exists();

      if (_fileExists) {
        String contents = await file.readAsString();
        grupos = loadGrupos(contents);
        setState(() {
          loading = false;
        });
      } else {
        print('Arquivo de grupos não foi localizado.');
      }
    } catch (e) {
      print('Ocorreu um erro: $e');
    }
  }

  static List<Grupo> loadGrupos(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Grupo>((json) => Grupo.fromJson(json)).toList();
  }

  @override
  void dispose() {
    this.txtPlaca.dispose();
    this.txtConjunto.dispose();
    this.txtLocalizacao.dispose();
    this.txtResponsavel.dispose();
    this.txtGrupo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getGrupos();
    super.initState();
  }

  Widget rowGrupo(Grupo grupo) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(grupo.nome),
          SizedBox(
            width: 10.0,
          ),
          Text(
            grupo.idgrupo,
          )
        ]);
  }

  void BuscaPatrimonio() {
    setState(() {
      Grupo gp = new Grupo();
      gp = grupos.firstWhere((g) => g.idgrupo.contains(this.idGrupo));

      this.idGrupo = gp.idgrupo;
      this.idGrupoold = gp.idgrupo;
      this.txtGrupo.text = gp.nome.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Column coluna = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: this.txtPlaca,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Placa de tombamento"),
          onChanged: (value) => BuscaPatrimonio(),
          validator: (value) {
            if (value.isEmpty) {
              return "Informe o código de barras";
            }
          },
        ),
        TextFormField(
          controller: this.txtConjunto,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Conjunto"),
        ),
        TextFormField(
          controller: txtLocalizacao,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Localização"),
        ),
        loading
            ? CircularProgressIndicator()
            : searchTextFieldGrupo = AutoCompleteTextField<Grupo>(
                key: keyGrupo,
                clearOnSubmit: false,
                suggestions: grupos,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(labelText: "Grupo"),
                controller: this.txtGrupo,
                itemFilter: (item, query) {
                  return item.nome
                      .toUpperCase()
                      .startsWith(query.toUpperCase());
                },
                itemSorter: (a, b) {
                  return a.nome.compareTo(b.nome);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextFieldGrupo.textField.controller.text = item.nome;
                    this.idGrupo = item.idgrupo;
                  });
                },
                itemBuilder: (context, item) {
                  return rowGrupo(item);
                },
              ),
        TextFormField(
          controller: this.txtResponsavel,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Responsável"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  bool manipulou = manipularEstoque();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(manipulou ? "Informação" : "Erro"),
                      elevation: 24.0,
                      content: Text(msgErro),
                      actions: [
                        FlatButton(
                          child: Text("FECHAR"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
            RaisedButton(
              onPressed: () => limparForm(),
              child: Text('Limpar'),
            )
          ],
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(key: _formkey, child: (coluna)),
        ),
      ),
    );
  }
}
