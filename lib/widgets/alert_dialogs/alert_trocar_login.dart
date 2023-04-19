import 'dart:convert';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../itens_bottom.dart';
import '../../logado.dart';
import '../erro_servidor.dart';
import '/logado.dart' as logado;

alertaDialogTrocarLogin(BuildContext context) {
  loginDenovo() async {
    var url = Uri.parse(
        '${logado.comecoAPI}login/?fn=login&email=${logado.emailUser}&senha=${logado.senhaUser}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  var size = MediaQuery.of(context).size;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return FutureBuilder<dynamic>(
        future: loginDenovo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.05),
                title: ShimmerWidget.rectangular(
                  height: size.height * 0.01,
                  width: size.width * 0.05,
                ),
                content: SizedBox(
                  width: size.width * 0.98,
                  child: ShimmerWidget.rectangular(
                    height: size.height * 0.05,
                    circular: 60,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          }

          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Qual empresa deseja acessar?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            content: SizedBox(
              width: size.width * 0.98,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['login'].length,
                itemBuilder: (context, index) {
                  var tipo = snapshot.data!['login'][index]['tipo'];
                  var nomePJ = snapshot.data!['login'][index]['razao_social'];
                  var nomePF =
                      snapshot.data!['login'][index]['razao_social_pf'];
                  var codigoId = snapshot.data!['login'][index]['codigo'];
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.008, horizontal: 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: logado.kButtonColor,
                          fixedSize: Size.fromWidth(double.maxFinite),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderButton),
                          ),
                        ),
                        onPressed: () {
                          efetuaLogin(context, logado.emailUser,
                              logado.senhaUser, codigoId);
                          ItensBottom(currentTab: 0);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.023),
                          child: SizedBox(
                            width: size.width * 0.65,
                            child: Text(
                              tipo == 'CPF' ? '$nomePF' : '$nomePJ',
                              textAlign: TextAlign.center,
                              textWidthBasis: TextWidthBasis.longestLine,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )

                      //  logado.buildCustomButton(
                      //     context, tipo == 'CPF' ? '$nomePF' : '$nomePJ',
                      //     onPressed: () {
                      //   efetuaLogin(context, logado.emailUser, logado.senhaUser,
                      //       codigoId);
                      //   ItensBottom(currentTab: 0);
                      // })
                      );
                },
              ),
            ),
          );
        },
      );
    },
  );
}
