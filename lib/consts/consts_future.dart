import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/alert_dialogs/alert_avisos.dart';
import 'consts.dart';

class ConstsFuture {
  static Future navigatorPageRoute(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

  static Future navigatorRemoveUntil(BuildContext context, Widget route) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => route,
        ),
        (route) => false);
  }

  static Future<dynamic> restApi(String api) async {
    var url = Uri.parse("${Consts.comecoAPI}$api");
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } catch (e) {
        return {'erro': true, 'mensagem': 'Tente Novamente'};
      }
    } else {
      return false;
    }
  }

  static Future mensagemSolicitacao(int idCorresp,
      {required int tipoEnvio}) async {
    var url = Uri.parse(
        '${Consts.comecoAPI}/textos-avisos/?fn=tipo_envio&id=$tipoEnvio&idcliente=${Consts.idCliente}&idcorresp=$idCorresp');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  static Future verificarAvisos(context) async {
    var url = Uri.parse(
        '${Consts.comecoAPI}avisos-diversos/index.php?fn=mostrarAviso');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var avisosBody = json.decode(resposta.body);
      var isVisible = avisosBody['visible'];
      isVisible == 1
          ? alertaDialogAviso(context)
          : Consts.avisoisVisible == false;
    } else {
      return {'erro': true, 'mensagem': 'Algo Saiu Mau'};
    }
  }
}
