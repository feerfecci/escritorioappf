// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:escritorioappf/screens/carrinho/carrinho_screen.dart';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../../widgets/erro_servidor.dart';

faturaApiCliente() async {
  var url = Uri.parse(
      // '${logado.comecoAPI}faturas/?fn=lista_faturas&idcliente=${logado.idIugu}&api_token=${logado.tokenIugu}');
      'https://api.iugu.com/v1/invoices/?customer_id=${logado.idIugu}&api_token=${logado.tokenIugu}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

_launchUrl(Uri url) async {
  await launchUrl(
    mode: LaunchMode.inAppWebView,
    url,
  );
}

pegarQRCodefatura(var IdFatura) async {
  var url = Uri.parse(
      'https://api.iugu.com/v1/invoices/$IdFatura?&api_token=${logado.tokenIugu}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

copiaButton(var fatId) {
  return FutureBuilder<dynamic>(
      future: pegarQRCodefatura(fatId),
      builder: (BuildContext context, snapshot) {
        var size = MediaQuery.of(context).size;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.002,
            ),
            child: ShimmerWidget.rectangular(
              height: size.height * 0.065,
              width: size.width * 0.5,
              circular: 60,
            ),
          );
        } else if (snapshot.hasData == false || snapshot.hasError == true) {
          return SizedBox(
            width: size.width * 0.50,
          );
        } else {
          if (snapshot.data!['pix'] != null) {
            return SizedBox(
                width: size.width * 0.50,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    var qrCodePix = snapshot.data!['pix']['qrcode_text'];
                    var boleto = snapshot.data!['bank_slip'];

                    Widget _buildPixButton() {
                      return ConstsWidget.buildCustomButton(
                        context,
                        'Copiar código pix',
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Clipboard.setData(
                            ClipboardData(
                              text: qrCodePix,
                            ),
                          );
                          buildMinhaSnackBar(
                            context,
                            categoria: 'codigo_pix_copiado',
                          );
                        },
                      );
                    }

                    Widget _buildBoletoButton() {
                      return ConstsWidget.buildCustomButton(
                        context,
                        snapshot.data!['bank_slip']['digitable_line'],
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: snapshot.data!['bank_slip']
                                  ['digitable_line'],
                            ),
                          );
                          buildMinhaSnackBar(
                            context,
                            categoria: 'codigo_pix_copiado',
                          );
                        },
                      );
                    }

                    if (qrCodePix != null && boleto == null) {
                      return _buildPixButton();
                    } else if (qrCodePix == null && boleto != null) {
                      return _buildBoletoButton();
                    } else if (qrCodePix == null && boleto == null) {
                      return Column(
                        children: [
                          _buildPixButton(),
                          _buildBoletoButton(),
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: 1,
                      );
                    }
                  },
                ));
          }
          return SizedBox(
            height: double.minPositive,
          );
        }
      });
}

showFaturas() {
  Widget buildFinancLoading(BuildContext context) {
    var size = MediaQuery.of(context).size;
    listTile(
        {required double paddingHeight,
        required double height,
        required double width,
        double circular = 16}) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * paddingHeight,
        ),
        child: ShimmerWidget.rectangular(
          height: size.height * height,
          width: size.width * width,
          circular: circular,
        ),
      );
    }

    return MeuBoxShadow(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listTile(paddingHeight: 0.005, height: 0.01, width: 0.4),
          listTile(paddingHeight: 0.005, height: 0.01, width: 0.4),
          listTile(paddingHeight: 0.01, height: 0.01, width: 0.1),
          listTile(
              paddingHeight: 0.01, height: 0.065, width: 0.9, circular: 60),
        ],
      ),
    ));
  }

  return FutureBuilder<dynamic>(
    future: faturaApiCliente(),
    builder: (BuildContext context, snapshot) {
      var size = MediaQuery.of(context).size;
      if (snapshot.connectionState == ConnectionState.waiting) {
        return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) => buildFinancLoading(context));
      } else if (snapshot.hasData) {
        return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data['items'].length,
          itemBuilder: ((context, index) {
            var usuario = snapshot.data!['items'];
            var usuario2 = snapshot.data!['items'][index];
            dynamic stringData = usuario[index]["due_date"];
            var parsedDate = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(stringData))
                .toString();
            var idFatura = usuario[index]['id'];
            usuario[index]["items"];
            return MeuBoxShadow(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['items'][index]['items'].length,
                    itemBuilder: ((context, index) {
                      var descri = usuario2["items"][index]["description"];
                      return SizedBox(
                        width: size.width * 0.84,
                        child: ConstsWidget.buildTextTitle(descri),
                      );
                    }),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.006),
                    child: ConstsWidget.buildTextSubTitle(
                        'Vencimento: $parsedDate'),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.006),
                    child: Text(
                      usuario[index]["total"],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.006),
                    child: Center(
                        child: ConstsWidget.buildCustomButton(
                      context,
                      usuario[index]["status"] == "canceled"
                          ? 'Ver fatura Cancelada'
                          : usuario[index]["status"] == "pending"
                              ? 'Ver fatura Pendente'
                              : 'Ver fatura Paga',
                      onPressed: () {
                        final Uri url = Uri.parse(
                          usuario[index]['secure_url'],
                        );
                        _launchUrl(
                          url,
                        );
                      },
                      color: usuario[index]["status"] == "canceled"
                          ? Color.fromRGBO(63, 82, 100, 1)
                          : usuario[index]["status"] == "pending"
                              ? Color.fromRGBO(240, 204, 34, 1)
                              : Color.fromRGBO(117, 189, 89, 1),
                    )),
                  ),
                  if (usuario[index]["status"] == "pending")
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.01),
                      child: ConstsWidget.buildCustomButton(
                          context, 'Fazer Pagamento', onPressed: () {
                        showCustomModalBottom(
                            context,
                            isDismissible: true,
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.01),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.01),
                                    child: ConstsWidget.buildTextTitle(
                                        'Escolha a forma de pagamento'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.006),
                                    child: ConstsWidget.buildTextSubTitle(
                                        'Vencimento: $parsedDate'),
                                  ),
                                  copiaButton(idFatura)
                                ],
                              ),
                            ));
                      }),
                    ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            );
          }),
        );
      } else {
        return ErroServidor();
      }
    },
  );
}
