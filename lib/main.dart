import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'Inventario.dart';
import 'package:ext_storage/ext_storage.dart';
//import 'package:build_daemon/change_provider.dart';
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

  String _jsonString;
  File file;

  static List<Inventario> inventariado = new List<Inventario>();
  AutoCompleteTextField searchTextFieldGrupo;
  AutoCompleteTextField searchTextFieldResp;
  AutoCompleteTextField searchTextFieldLocal;
  AutoCompleteTextField searchTextFieldConj;
  GlobalKey<AutoCompleteTextFieldState<Inventario>> keyGrupo = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Inventario>> keyResp = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Inventario>> keyLocal = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Inventario>> keyConj = new GlobalKey();

  final txtPlaca = TextEditingController();
  final txtConjunto = TextEditingController();
  final txtLocalizacao = TextEditingController();
  final txtResponsavel = TextEditingController();
  final txtGrupo = TextEditingController();

  int idConjunto;
  int idLocalizacao;
  int idGrupo;
  int idResponsavel;

  int idConjuntoOld;
  int idLocalizacaoold;
  int idGrupoold;
  int idResponsavelold;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void mostraMensagem(String manipulou) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(manipulou),
        elevation: 24.0,
        content: Text(msgErro),
        actions: <Widget>[
          FlatButton(
            child: Text("FECHAR"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  bool manipularEstoque() {
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
      _writeJson();

      this.msgErro = "Item coletado.";
      return true;
    }
  }

  Future<String> get _localPath async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    final directory = Directory(path);
    return directory.path;
  }

  Future<File> get _localFileDados async {
    final path = await _localPath;
    return File('$path/inventario.json');
  }

  void limparForm() {
    setState(() {
      this.txtPlaca.text = this.txtConjunto.text = this.txtGrupo.text =
          this.txtLocalizacao.text = this.txtResponsavel.text = "";

      this.idConjunto =
          this.idLocalizacao = this.idGrupo = this.idResponsavel = 0;

      this.idConjuntoOld =
          this.idLocalizacaoold = this.idGrupoold = this.idResponsavelold = 0;
    });
  }

  void getInventario() async {
    try {
      file = await _localFileDados;

      bool _fileExists = await file.exists();

      if (_fileExists) {
        _jsonString = await file.readAsString();

        inventariado = loadInventario(_jsonString);
        setState(() {
          loading = false;
        });
      } else {
        print('Arquivo de dados do inventario não foi localizado.');
      }
    } catch (e) {
      print('Ocorreu um erro: $e');
    }
  }

  static List<Inventario> loadInventario(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Inventario>((json) => Inventario.fromJson(json)).toList();
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
    getInventario();
    super.initState();
  }

  Widget rowGrupo(Inventario inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.grupo),
          SizedBox(
            width: 10.0,
          ),
          Text(
            inventario.idgrupo.toString(),
          )
        ]);
  }

  Widget rowResp(Inventario inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.responsavel),
          SizedBox(
            width: 10.0,
          ),
          Text(
            inventario.idresponsavel.toString(),
          )
        ]);
  }

  Widget rowLocal(Inventario inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.localizacao),
          SizedBox(
            width: 10.0,
          ),
          Text(
            inventario.idlocalizacao.toString(),
          )
        ]);
  }

  Widget rowConj(Inventario inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.conjunto),
          SizedBox(
            width: 10.0,
          ),
          Text(
            inventario.idconjunto.toString(),
          )
        ]);
  }

  void BuscaPatrimonio() {
    setState(() {
      Inventario di = new Inventario();
      di = inventariado
          .firstWhere((i) => i.placa.toString().contains(this.txtPlaca.text));

      this.idGrupo = di.idgrupo;
      this.idGrupoold = di.idgrupo;
      this.txtGrupo.text = di.grupo.toUpperCase();

      this.idResponsavel = di.idresponsavel;
      this.idResponsavelold = di.idresponsavel;
      this.txtResponsavel.text = di.responsavel.toUpperCase();

      this.idLocalizacao = di.idlocalizacao;
      this.idLocalizacaoold = di.idlocalizacao;
      this.txtLocalizacao.text = di.localizacao.toUpperCase();

      this.idConjunto = di.idconjunto;
      this.idConjuntoOld = di.idconjunto;
      this.txtConjunto.text = di.conjunto.toUpperCase();
    });
  }

  void _writeJson() async {
    try {
      Inventario di = inventariado
          .firstWhere((i) => i.placa.toString().contains(this.txtPlaca.text));

      di.idconjunto = this.idConjunto;
      di.idlocalizacao = this.idLocalizacao;
      di.idresponsavel = this.idResponsavel;
      di.idgrupo = this.idGrupo;
      di.conjunto = this.txtConjunto.text;
      di.localizacao = this.txtLocalizacao.text;
      di.responsavel = this.txtResponsavel.text;
      di.grupo = this.txtGrupo.text;
      di.flgaltera = "S";

      String strInventario = jsonEncode(di);
      Map<String, dynamic> _newJson = jsonDecode(strInventario);

      List<dynamic> _json = json.decode(_jsonString);
      for (int i = 0; i <= _json.length - 1; i++) {
        if (_json[i]["placa"] == di.placa) {
          _json[i] = _newJson;
          break;
        }
      }

      file.writeAsStringSync(json.encode(_json));
    } catch (e) {
      print('Ocorreu um errro: $e');
    }
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
        loading
            ? CircularProgressIndicator()
            : searchTextFieldConj = AutoCompleteTextField<Inventario>(
                key: keyConj,
                clearOnSubmit: false,
                suggestions: inventariado,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(labelText: "Conjunto"),
                controller: this.txtConjunto,
                itemFilter: (item, query) {
                  return item.conjunto
                      .toUpperCase()
                      .startsWith(query.toUpperCase());
                },
                itemSorter: (a, b) {
                  return a.conjunto.compareTo(b.conjunto);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextFieldConj.textField.controller.text =
                        item.conjunto;
                    this.idConjunto = item.idconjunto;
                  });
                },
                itemBuilder: (context, item) {
                  return rowConj(item);
                },
              ),
        loading
            ? CircularProgressIndicator()
            : searchTextFieldLocal = AutoCompleteTextField<Inventario>(
                key: keyLocal,
                clearOnSubmit: false,
                suggestions: inventariado,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(labelText: "Localização"),
                controller: this.txtLocalizacao,
                itemFilter: (item, query) {
                  return item.localizacao
                      .toUpperCase()
                      .startsWith(query.toUpperCase());
                },
                itemSorter: (a, b) {
                  return a.localizacao.compareTo(b.localizacao);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextFieldLocal.textField.controller.text =
                        item.localizacao;
                    this.idLocalizacao = item.idlocalizacao;
                  });
                },
                itemBuilder: (context, item) {
                  return rowLocal(item);
                },
              ),
        loading
            ? CircularProgressIndicator()
            : searchTextFieldGrupo = AutoCompleteTextField<Inventario>(
                key: keyGrupo,
                clearOnSubmit: false,
                suggestions: inventariado,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(labelText: "Grupo"),
                controller: this.txtGrupo,
                itemFilter: (item, query) {
                  return item.grupo
                      .toUpperCase()
                      .startsWith(query.toUpperCase());
                },
                itemSorter: (a, b) {
                  return a.grupo.compareTo(b.grupo);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextFieldGrupo.textField.controller.text = item.grupo;
                    this.idGrupo = item.idgrupo;
                  });
                },
                itemBuilder: (context, item) {
                  return rowGrupo(item);
                },
              ),
        loading
            ? CircularProgressIndicator()
            : searchTextFieldResp = AutoCompleteTextField<Inventario>(
                key: keyResp,
                clearOnSubmit: false,
                suggestions: inventariado,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(labelText: "Responsável"),
                controller: this.txtResponsavel,
                itemFilter: (item, query) {
                  return item.responsavel
                      .toUpperCase()
                      .startsWith(query.toUpperCase());
                },
                itemSorter: (a, b) {
                  return a.responsavel.compareTo(b.responsavel);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextFieldGrupo.textField.controller.text =
                        item.responsavel;
                    this.idResponsavel = item.idresponsavel;
                  });
                },
                itemBuilder: (context, item) {
                  return rowResp(item);
                },
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  bool manipulou = manipularEstoque();
                  mostraMensagem(manipulou ? "Informação" : "Erro");
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
