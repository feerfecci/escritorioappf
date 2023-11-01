import 'dart:convert';

import 'package:flutter/material.dart';

import '../itens_bottom.dart';
import '../repository/shared_preferences.dart';
import '../screens/login/login_screen.dart';
import '../widgets/alert_dialogs/alert_avisos.dart';
import '../widgets/alert_dialogs/alert_senha_padrao.dart';
import '../widgets/alert_dialogs/alert_trocar_login.dart';
import '../widgets/erro_servidor.dart';
import 'package:http/http.dart' as http;
import '../widgets/snackbar/snack.dart';
import 'consts.dart';

class ConstsFuture {
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

  static Future navigatorRoute(BuildContext context, Widget pageRoute) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return pageRoute;
    }));
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

/*  static Future efetuaLogin(
      context, String email, String senha, String codigoCliente,
      {bool isToRemember = false}) async {
    // showSnackBar(context) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   return buildMinhaSnackBar(context,
    //       categoria: 'login_erro',  );
    // }
    final LocalSetting prefService = LocalSetting();
    var url = Uri.parse(
        '${Consts.comecoAPI}login/?fn=login&email=$email&senha=$senha${codigoCliente != '' ? '&codigo=$codigoCliente' : ''}');

    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      dynamic login = json.decode(resposta.body);
      bool erro = login['erro'];

      if (erro == false) {
        var parteLogin = login['login'][0];
        if (codigoCliente == '') {
          Consts.totalEmpresas = login['total_empresas'];
        }
        Consts.emailUser == email;
        Consts.senhaUser == senha;
        Consts.periodo == parteLogin['ultimo_login'];

        Consts.razaoSocial == parteLogin['razao_social'];
        Consts.codigo == parteLogin['codigo'];
        Consts.idCliente == parteLogin['id'];
        Consts.idIugu == parteLogin['idiugu'];
        Consts.sessCar == parteLogin['sesscar'];
        Consts.nomeSaudacao == parteLogin["nome_saudacao"];
        Consts.creditoCliente == parteLogin['credito'];
        Consts.statusCliente == parteLogin['financeiro']['aviso'];

        ConstsFuture.navigatorRoute(context, ItensBottom(currentTab: 0));

        ConstsFuture.verificarAvisos(context);
        if (senha == '123mudar') {
          alertDialogSenhaPadrao(context);
        }

        if (Consts.totalEmpresas != 1 && codigoCliente == '') {
          // alertaTrocarUsuario(context);
          alertaDialogTrocarLogin(context);
        }
        if (isToRemember) {
          prefService.createChache(email, senha);
        }
      } else {
        prefService.readChache().then((value) {
          Map<String, dynamic> infos = value;

          if (infos['email'] != null) {
            ConstsFuture.navigatorRoute(context, LoginScreen());
            prefService.removeChache();

            return buildMinhaSnackBar(
              context,
              categoria: 'login_erro',
            );
          } else {
            return buildMinhaSnackBar(
              context,
              categoria: 'login_erro',
            );
          }
        });
      }
    } else {
      return ErroServidor();
    }
  }
*/
}
