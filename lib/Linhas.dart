import 'package:flutter/material.dart';
import 'package:flutter_app/Conjunto.dart';
import 'package:flutter_app/Grupo.dart';
import 'package:flutter_app/Localizacao.dart';
import 'package:flutter_app/Responsavel.dart';

class Linhas {
  Widget rowGrupo(Grupo inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.grupo),
          SizedBox(
            width: 10.0,
          ),
        ]);
  }

  Widget rowResp(Responsavel inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.responsavel),
          SizedBox(
            width: 10.0,
          ),
        ]);
  }

  Widget rowLocal(Localizacao inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.localizacao),
          SizedBox(
            width: 10.0,
          ),
        ]);
  }

  Widget rowConj(Conjunto inventario) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(inventario.conjunto),
          SizedBox(
            width: 10.0,
          ),
        ]);
  }
}
