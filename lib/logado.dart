library globals;

import 'dart:async';
import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Consts/Consts.dart';
import 'itens_bottom.dart';
import 'repository/shared_preferences.dart';
import 'screens/login/login_screen.dart';
import 'widgets/alert_dialogs/alert_avisos.dart';
import 'widgets/alert_dialogs/alert_senha_padrao.dart';
import 'widgets/alert_dialogs/alert_trocar_login.dart';

const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
const kButtonColor = Color.fromARGB(255, 0, 134, 252);

int bolinha = 0;
var creditoCliente = 0;
String emailUser = '';
String senhaUser = '';
int totalEmpresas = 0;
String codigo = '';
String razaoSocial = '';
String razao2 = '';
String periodo = '';
int idCliente = 0;
String nomeSaudacao = '';
bool avisoisVisible = false;
String idIugu =
//514E Producao
//  "514EC71FE8354FA5A7AF6114BE583DFC";
    //"D48082CDC3FB458388E599B8BE589989";
    '';
var sessCar = '';
String statusCliente = '';
String tokenIugu =
//"0D" teste
    //'0D77FB693D61B5A215E22544A637660B51B4FE40781CD0395FB8FCAC1FDFC7AE';
    '2D283E3209868E23A3BEA593AF76B115E9DE073AE77AA1C6F6A2DD2E84A59E0A';

mensagemSolicitacao(int idCorresp, {required int tipoEnvio}) async {
  var url = Uri.parse(
      '${Consts.comecoAPI}/textos-avisos/?fn=tipo_envio&id=$tipoEnvio&idcliente=$idCliente&idcorresp=$idCorresp');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

Future navigatorRoute(BuildContext context, Widget pageRoute) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) {
    return pageRoute;
  }));
}
// Widget buildCardShimmer(BuildContext context) {
//   var size = MediaQuery.of(context).size;
//   return Shimmer.fromColors(
//       baseColor: Colors.grey[400]!,
//       highlightColor: Colors.grey[200]!,
//       child: Container(
//         // color: Colors.black,
//         padding: EdgeInsets.all(size.height * 0.004),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).shadowColor,
//               spreadRadius: 0,
//               blurRadius: 5,
//               offset: Offset(5, 5), // changes position of shadow
//             ),
//           ],
//         ),
//       ));
// }

verificarAvisos(context) async {
  var url =
      Uri.parse('${Consts.comecoAPI}avisos-diversos/index.php?fn=mostrarAviso');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    var avisosBody = json.decode(resposta.body);
    var isVisible = avisosBody['visible'];
    isVisible == 1 ? alertaDialogAviso(context) : avisoisVisible == false;
  } else {
    return null;
  }
}

efetuaLogin(context, String email, String senha, String codigoCliente,
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
        totalEmpresas = login['total_empresas'];
      }
      emailUser = email;
      senhaUser = senha;
      periodo = parteLogin['ultimo_login'];
      razaoSocial = parteLogin['razao_social'];
      codigo = parteLogin['codigo'];
      idCliente = parteLogin['id'];
      idIugu = parteLogin['idiugu'];
      sessCar = parteLogin['sesscar'];
      nomeSaudacao = parteLogin["nome_saudacao"];
      creditoCliente = parteLogin['credito'];
      statusCliente = parteLogin['financeiro']['aviso'];
      if (codigoCliente == '') {
        navigatorRoute(context, ItensBottom(currentTab: 0));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ItensBottom(currentTab: 0),
            ),
            (route) => false);
      }

      verificarAvisos(context);

      if (senha == '123mudar') {
        alertDialogSenhaPadrao(context);
      }

      if (totalEmpresas != 1 && codigoCliente == '') {
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
          navigatorRoute(context, LoginScreen());
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
