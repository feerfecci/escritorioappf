// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/cabecalho.dart';
import 'package:escritorioappf/widgets/custom_drawer.dart';
import 'package:escritorioappf/widgets/nested_scroll.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../logado.dart' as logado;
import '../../widgets/alert_dialogs/alert_vazio.dart';
import '../../widgets/erro_servidor.dart';
import '../../widgets/shimmer_widget.dart';

class PlanosScreen extends StatefulWidget {
  const PlanosScreen({super.key});

  @override
  State<PlanosScreen> createState() => _PlanosScreenState();
}

pegarPlanos() async {
  var url = Uri.parse(
      '${logado.comecoAPI}planos/index.php?fn=lista&idcliente=${logado.idIugu}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

Widget buildListItens(String title, String subTitle) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        logado.buildTextTitle(title),
        Text(subTitle),
      ],
    ),
  );
}

class _PlanosScreenState extends State<PlanosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    listTileLoading({
      double paddingHeight = 0.01,
      double height = 0.01,
      required double width,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * paddingHeight,
        ),
        child: ShimmerWidget.rectangular(
          height: size.height * height,
          width: size.width * width,
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      endDrawer: CustomDrawer(
        fundo: '${logado.fundoAssets}assinaturas.jpg',
      ),
      body: MeuNested(
        imageAsset: "${logado.fundoAssets}assinaturas.jpg",
        context: context,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            // await correspApi();
          },
          child: ListView(
            children: [
              Cabecalho(
                context: context,
                titulo: 'Planos',
                subTitulo: 'Confira seus Planos',
                child: FutureBuilder<dynamic>(
                    future: pegarPlanos(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) => MeuBoxShadow(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                listTileLoading(width: 0.3),
                                listTileLoading(width: 0.2),
                                listTileLoading(width: 0.5),
                                listTileLoading(width: 0.4),
                                listTileLoading(width: 0.25),
                                listTileLoading(width: 0.6, paddingHeight: 0),
                              ],
                            ),
                          )),
                        );
                      } else if (snapshot.hasData == false ||
                          snapshot.hasError == true) {
                        return ErroServidor();
                      } else if (snapshot.data['mensagem'] ==
                          "Nenhuma correspondência localizada!") {
                        return CampoVazio(
                            mensagemAvisoVazio: snapshot.data['mensagem']);
                      }
                      int contagem = snapshot.data['totalItems'];
                      formatDate(String? stringData) {
                        var parseDate;
                        if (stringData != null) {
                          parseDate = DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(stringData))
                              .toString();
                        }
                        return parseDate;
                      }

                      return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: contagem,
                          itemBuilder: (context, index) {
                            var items = snapshot.data['items'][index];
                            bool status = items['suspended'];
                            var valor = items['recent_invoices'][0]['total'];
                            String? expiraEm = items['expires_at'];
                            String? comecaEm = items['updated_at'];

                            return MeuBoxShadow(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01,
                                    vertical: size.height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        logado.buildTextTitle('Status: '),
                                        logado.buildTextTitle(
                                          ' ${status != true ? 'Ativa' : 'Suspensa'}',
                                          color: status != true
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ],
                                    ),
                                    buildListItens('Valor: ', '$valor'),
                                    buildListItens('Data de início: ',
                                        '${formatDate(comecaEm)}'),
                                    buildListItens('Data de expiração: ',
                                        '${formatDate(expiraEm)}'),
                                    logado.buildTextTitle('ID Assinatura: '),
                                    Text('${items['id']}'),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
