library globals;

import 'dart:async';

import 'package:escritorioappf/widgets/alert_dialogs/alert_devendo.dart';
import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'itens_bottom.dart';
import 'repository/shared_preferences.dart';
import 'screens/login/login_screen.dart';
import 'widgets/alert_dialogs/alert_avisos.dart';
import 'widgets/alert_dialogs/alert_senha_padrao.dart';
import 'widgets/alert_dialogs/alert_trocar_login.dart';

const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
const kButtonColor = Color.fromARGB(255, 0, 134, 252);

int bolinha = 0;
double fontTitulo = 15;
double fontSubTitulo = 14;
double borderButton = 60;
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
const String comecoAPI = 'https://evbrapp.com/api/';
const String fundoAssets = 'https://escritorioapp.com/img/fundo-tela-';
const String iconAssets = 'https://escritorioapp.com/img/ico-';
const String arquivoAssets = 'https://escritorioapp.com/img/';

Widget buildCustomButton(BuildContext context, String title,
    {IconData? icon,
    double? altura,
    Color? color = kButtonColor,
    required void Function()? onPressed}) {
  var size = MediaQuery.of(context).size;
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      fixedSize: Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderButton),
      ),
    ),
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: size.width * 0.015,
          ),
          icon != null ? Icon(size: 18, icon, color: Colors.white) : SizedBox(),
        ],
      ),
    ),
  );
}

Widget buildTextTitle(String title, {textAlign, color}) {
  return Text(
    title,
    maxLines: 20,
    textAlign: textAlign,
    style: TextStyle(
      color: color,
      fontSize: fontTitulo,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildTextSubTitle(String title, {color}) {
  return Text(
    title,
    maxLines: 20,
    style: TextStyle(
      color: color,
      fontSize: fontSubTitulo,
      fontWeight: FontWeight.normal,
    ),
  );
}

mensagemSolicitacao(int idCorresp, {required int tipoEnvio}) async {
  var url = Uri.parse(
      '$comecoAPI/textos-avisos/?fn=tipo_envio&id=$tipoEnvio&idcliente=$idCliente&idcorresp=$idCorresp');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

Widget buildLayout(BuildContext context,
    {required Widget seMobile, required Widget seWeb}) {
  return LayoutBuilder(builder: (context, constraints) {
    final bool isMobile = constraints.maxWidth < 1000;
    return isMobile ? seMobile : seWeb;
  });
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
  var url = Uri.parse('${comecoAPI}avisos-diversos/index.php?fn=mostrarAviso');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    var avisosBody = json.decode(resposta.body);
    var isVisible = avisosBody['visible'];
    isVisible == 1 ? alertaDialogAviso(context) : avisoisVisible == false;
  } else {
    return null;
  }
}

efetuaLogin(context, String email, String senha, String codigoCliente) async {
  // showSnackBar(context) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   return buildMinhaSnackBar(context,
  //       categoria: 'login_erro', icon: Icons.check_circle_outline_outlined);
  // }
  if (codigoCliente == '') {
    var url =
        Uri.parse('${comecoAPI}login/?fn=login&email=$email&senha=$senha');
    
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      dynamic login = json.decode(resposta.body);
      bool erro = login['erro'];
      if (erro == false) {
        var parteLogin = login['login'][0];
        emailUser = email;
        senhaUser = senha;
        totalEmpresas = login['total_empresas'];
        periodo = parteLogin['ultimo_login'];
        razaoSocial = parteLogin['razao_social'];
        codigo = parteLogin['codigo'];
        idCliente = parteLogin['id'];
        idIugu = parteLogin['idiugu'];
        sessCar = parteLogin['sesscar'];
        nomeSaudacao = parteLogin["nome_saudacao"];
        creditoCliente = parteLogin['credito'];
        statusCliente = parteLogin['financeiro']['aviso'];

        navigatorRoute(context, ItensBottom(currentTab: 0));
        Timer(Duration(seconds: 4), () {
          verificarAvisos(context);
          if (senha == '123mudar') {
            alertDialogSenhaPadrao(context);
          }
        });
        if (totalEmpresas != 1) {
          // alertaTrocarUsuario(context);
          alertaDialogTrocarLogin(context);
        }
      } else {
        final LocalSetting prefService = LocalSetting();
        prefService.readChache().then((value) {
          Map<String, dynamic> infos = value;
          if (infos.values.first != null) {
            navigatorRoute(context, LoginScreen());
            prefService.removeChache();
            return buildMinhaSnackBar(context,
                categoria: 'login_erro',
                icon: Icons.check_circle_outline_outlined);
          } else {
            return buildMinhaSnackBar(context,
                categoria: 'login_erro',
                icon: Icons.check_circle_outline_outlined);
          }
        });
      }
    } else {
      return ErroServidor();
    }
  } else {
    var url = Uri.parse(
        '${comecoAPI}login/?fn=login&email=$email&senha=$senha&codigo=$codigoCliente');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      dynamic login = json.decode(resposta.body);
      bool erro = login['erro'];

      if (erro == false) {
        var parteLogin = login['login'][0];
        emailUser = email;
        senhaUser = senha;
        periodo = parteLogin['ultimo_login'];
        razaoSocial = parteLogin['razao_social'];
        codigo = parteLogin['codigo'];
        idCliente = parteLogin['id'];
        idIugu = parteLogin['idiugu'];
        sessCar = parteLogin['sesscar'];
        statusCliente = parteLogin['financeiro']['aviso'];
        nomeSaudacao = parteLogin["nome_saudacao"];
        creditoCliente = parteLogin['credito'];

        navigatorRoute(context, ItensBottom(currentTab: 0));
        Timer(Duration(seconds: 4), () {
          verificarAvisos(context);
        });

        if (statusCliente != '') {
          return alertaDialogDevendo(context);
        }
      } else {
        return buildMinhaSnackBar(
          context,
          categoria: 'login_erro',
          icon: Icons.check_circle_outline_outlined,
        );
      }
    }
  }
}
