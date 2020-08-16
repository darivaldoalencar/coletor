import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int estoqueColetado = 0;
  int estoqueAtual = 10;
  int estoque = 0;
  String msgErro = "";
  final txtCodBarras = TextEditingController();
  final txtQtde = TextEditingController();

  AlertDialog alertar(erro) {
    return AlertDialog(
      title: new Text("Erro"),
      elevation: 24.0,
      content: new Text(erro),
      actions: [
        new FlatButton(
          child: new Text("FECHAR"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  bool manipularEstoque() {
    if (txtCodBarras.text.length <= 0) {
      this.msgErro = "Informe o código de barras!";
      return false;
    } else if (txtQtde.text.length <= 0) {
      this.msgErro = "Informe a quantidade!";
      return false;
    } else {
      this.msgErro = "Item coletado!";
      this.estoque = int.parse(txtQtde.text);
      this.estoqueColetado += estoque;
      return true;
    }
    ;
  }

  void limparForm() {
    this.txtQtde.text = "";
    this.txtCodBarras.text = "";

    this.estoqueColetado = 0;
  }

  @override
  void dispose() {
    txtCodBarras.dispose();
    txtQtde.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          controller: txtCodBarras,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: "Código de barras", icon: Icon(Icons.texture)),
        ),
        TextFormField(
          controller: txtQtde,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              hintText: "Quantidade Contabilizada", icon: Icon(Icons.texture)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Coletado: $estoqueColetado',
              //style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Estoque: $estoqueAtual',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
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
                });
              },
              child: Text('Salvar'),
            ),
            RaisedButton(
              onPressed: () => {
                setState(() {
                  limparForm();
                })
              },
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
      body: Center(
        child: column,
      ),
    );
  }
}
