// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:escritorioappf/screens/correspondencias/widgets/indice_solicitacao.dart';
import 'package:escritorioappf/widgets/alert_dialogs/alert_vazio.dart';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/erro_servidor.dart';
import '../financeiro/financeiro_screen.dart';

correspApi() async {
  var url = Uri.parse(
      '${logado.comecoAPI}correspondencias/?fn=read&idcliente=${logado.idCliente}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class ListaCorresp extends StatefulWidget {
  const ListaCorresp({super.key});

  @override
  State<ListaCorresp> createState() => _ListaCorrespState();
}

adicionarCarrinho(int idCorresp) async {
  var url = Uri.parse(
      '${logado.comecoAPI}carrinho/index.php?fn=addcarrinho&idcliente=${logado.idCliente}&idcorresp=$idCorresp&sesscar=${logado.sessCar}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

mostrarImagem(String arquivo) async {
  var url = Uri.parse('https://escritorioapp.com/upload/$arquivo');
  await launchUrl(
    mode: LaunchMode.externalApplication,
    url,
  );
}

_launchUrl(codiRastreio) async {
  var url = Uri.parse(
      'https://linketrack.com/track?codigo=$codiRastreio&utm_source=track');
  await launchUrl(
    mode: LaunchMode.externalNonBrowserApplication,
    url,
  );
}

class _ListaCorrespState extends State<ListaCorresp> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildListTileLoading(
        {double heightPadding = 0.01,
        double height = 0.01,
        double width = double.infinity}) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * heightPadding,
        ),
        child: ShimmerWidget.rectangular(
          height: size.height * height,
          width: size.width * width,
        ),
      );
    }

    return FutureBuilder<dynamic>(
        future: correspApi(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                  ),
                  child: MeuBoxShadow(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildListTileLoading(width: 0.2),
                      buildListTileLoading(width: 0.6),
                      buildListTileLoading(heightPadding: 0.04),
                    ],
                  ))),
            );
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          } else if (snapshot.data['mensagem'] ==
              "Nenhuma correspondência localizada!") {
            return CampoVazio(mensagemAvisoVazio: snapshot.data['mensagem']);
          }
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!['correspondencias'].length,
            itemBuilder: (context, index) {
              var correspApi = snapshot.data!['correspondencias'][index];
              var dataCorres = DateFormat('dd/MM/yyyy').format(
                DateTime.parse(
                    snapshot.data['correspondencias'][index]['data']),
              );
              int idCorresp = correspApi['id'];
              int isBoxcard = correspApi['proibir_scan'];
              int statusCorresp = int.parse(correspApi['status']['id_status']);
              int etapaCorresp = correspApi['status']['etapa'];
              int tipoEnvio = correspApi['envio']['id_tipo_envio'];
              String codRastreio = correspApi['envio']['cod_rastreio'];
              String msg_proibir = correspApi['msg_proibir'];
              String nome_portador = correspApi['envio']['nome_portador'];
              String valor_total = correspApi['envio']['valor_total'];
              var totalArquivos = correspApi['arquivos']['total_arquivos'];
              // Widget de etapa
              Widget buildCircle(String title, String subtitle,
                  int etapaCorresp, int thisStatus,
                  {double width = 0.19}) {
                Color backColor = Colors.green;

                Widget child = Icon(
                  Icons.check_outlined,
                  weight: 90,
                );

                if (etapaCorresp < thisStatus) {
                  backColor = Colors.grey;
                  child = Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  );
                } else if (etapaCorresp == thisStatus) {
                  backColor = Colors.blue;
                  child = Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  );
                }

                return Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.010,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.white,
                        radius: 15,
                        backgroundColor: backColor,
                        child: child,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: SizedBox(
                            width: size.width * width,
                            child: Text(
                              subtitle,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                );
              }

              verificandoCartao(int idCorresp) {
                if (logado.statusCliente == "") {
                  if (isBoxcard == 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        showIndicePermitido(context, idCorresp),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          msg_proibir,
                          style: TextStyle(color: Colors.red),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            showIndiceProibido(context, idCorresp),
                          ],
                        )
                      ],
                    );
                  }
                } else {
                  return ExpansionTile(
                    title: Text(
                      'Há pendencias financeiras',
                      style: TextStyle(color: Colors.red),
                    ),
                    children: [
                      Html(data: logado.statusCliente),
                    ],
                  );
                }
              }

              indicadorEtapaStatus() {
                if (tipoEnvio == 5) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Contar e avisar o cliente, na API = 1
                      buildCircle('1', 'Verificando', etapaCorresp, 1),

                      //Descartada, na API = 9
                      buildCircle('2', 'Descartada', etapaCorresp, 8),
                    ],
                  );
                } else if (tipoEnvio == 0 && statusCorresp == 5) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Descartada, na API = 9
                      buildCircle('2', 'Descartada', etapaCorresp, 8),
                    ],
                  );
                } else if (tipoEnvio == 4) {
                  Widget buildEtapasRetirada(
                      double padddingMain, double paddingProt) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * padddingMain),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Aguardando retirada, na API = 6
                              buildCircle('1', 'Aguardando', etapaCorresp, 6),
                              //Retirada, na API = 8
                              buildCircle('2', 'Retirada', etapaCorresp, 7),
                            ],
                          ),
                        ),
                        etapaCorresp == 8
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * paddingProt),
                                child: Row(
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                      'Retirado por: ',
                                    ),
                                    ConstsWidget.buildTextTitle(nome_portador),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: size.height * paddingProt),
                                child: Row(
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        'Protocolo: '),
                                    ConstsWidget.buildTextTitle(
                                        idCorresp.toString()),
                                  ],
                                ),
                              )
                      ],
                    );
                  }

                  return ConstsWidget.buildLayout(context,
                      seMobile: buildEtapasRetirada(0.25, 0.015),
                      seWeb: buildEtapasRetirada(0.1, 0.015));
                } else if (statusCorresp == 2 ||
                    statusCorresp == 7 ||
                    statusCorresp == 8 ||
                    statusCorresp == 9 ||
                    statusCorresp == 10) {
                  return ConstsWidget.buildLayout(context,
                      seMobile: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Contar e avisar o cliente, na API = 1
                            buildCircle('1', 'Contando', etapaCorresp, 1),

                            //Pagamento pendente, No carrinho, Na fatura, API = 2
                            buildCircle('2', 'Pagamento', etapaCorresp, 2),

                            //Enviar do Cliente, na API = 3
                            buildCircle('3', 'Em Fila', etapaCorresp, 3),

                            //Enviado, na API = 5
                            buildCircle('4', 'Enviado', etapaCorresp, 4),
                          ],
                        ),
                      ),
                      seWeb: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.000005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Contar e avisar o cliente, na API = 1
                            buildCircle('1', 'Contando', etapaCorresp, 1,
                                width: 0.05),

                            //Pagamento pendente, No carrinho, Na fatura, API = 2
                            buildCircle('2', 'Pagamento', etapaCorresp, 2,
                                width: 0.05),

                            //Enviar do Cliente, na API = 3
                            buildCircle('3', 'Em Fila', etapaCorresp, 3,
                                width: 0.05),

                            //Enviado, na API = 5
                            buildCircle('4', 'Enviado', etapaCorresp, 4,
                                width: 0.05),
                          ],
                        ),
                      ));
                }
              }

              statusCorrespondencia() {
                switch (statusCorresp) {
                  //aguardando cliente
                  case 0:
                    return verificandoCartao(idCorresp);
                  //aguardando cliente
                  case 1:
                    return verificandoCartao(idCorresp);
                  //enviado
                  case 3:
                    if (codRastreio != "") {
                      return Center(
                        child: ConstsWidget.buildCustomButton(
                          context,
                          codRastreio,
                          icon: Icons.search_outlined,
                          onPressed: () {
                            _launchUrl(codRastreio);
                          },
                        ),
                      );
                    } else if (totalArquivos != 0) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 5),
                                  mainAxisExtent: 70,
                                  crossAxisCount:
                                      correspApi['arquivos']['items'].length ==
                                              1
                                          ? 1
                                          : 2),
                          itemCount: correspApi['arquivos']['items'].length,
                          itemBuilder: ((context, index) {
                            return TextButton(
                              onPressed: () {
                                mostrarImagem(correspApi['arquivos']['items']
                                    [index]['nome_arquivo']);
                              },
                              child: Column(
                                children: [
                                  ConstsWidget.buildTextTitle(
                                      correspApi['arquivos']['items'][index]
                                          ['nome_arquivo'],
                                      color: Theme.of(context).iconTheme.color),
                                  Icon(Icons.download,
                                      color: Theme.of(context).iconTheme.color),
                                ],
                              ),
                            );
                          }));
                    }
                    return ConstsWidget.buildCustomButton(
                        context, 'Faltou algo, nos comunique', onPressed: () {
                      launchWhatsAppSuporte();
                    }, icon: Icons.phone);
                  // TextButton(
                  //   child: Text('Faltou Algo, nos Comunique'),
                  //   onPressed: () {
                  //     launchWhatsAppSuporte();
                  //   },
                  // );

                  //pagamento pendente
                  case 8:
                    if (logado.statusCliente == "") {
                      // bool _carregando = false;
                      final RoundedLoadingButtonController btnControllerSucess =
                          RoundedLoadingButtonController();
                      void startLoading() async {
                        btnControllerSucess.success();
                      }

                      Widget buildRoudend(double padding) {
                        return RoundedLoadingButton(
                          controller: btnControllerSucess,
                          height: size.height * padding,
                          onPressed: () {
                            startLoading();
                            adicionarCarrinho(idCorresp);

                            buildMinhaSnackBar(
                              context,
                              categoria: 'adiconado_carrinho',
                            );

                            setState(() {
                              statusCorresp = 9;
                              statusCorrespondencia();
                            });
                          },
                          successIcon: Icons.check,
                          successColor: Colors.green,
                          color: logado.kButtonColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ConstsWidget.buildTextTitle('Total: $valor_total',
                                  color: Colors.white),
                              SizedBox(
                                width: size.width * 0.015,
                              ),
                              Icon(
                                  color: Colors.white,
                                  size: 18,
                                  Icons.shopping_cart_checkout_rounded),
                            ],
                          ),
                        );
                      }

                      return Center(
                          child: StatefulBuilder(builder: (context, setState) {
                        return ConstsWidget.buildLayout(context,
                            seMobile: buildRoudend(0.065),
                            seWeb: buildRoudend(0.09));
                      }));
                    } else {
                      return ExpansionTile(
                        title: Text(
                          'Há pendencias financeiras',
                          style: TextStyle(
                              color: Colors.red, fontSize: logado.fontTitulo),
                        ),
                        children: [
                          Html(data: logado.statusCliente),
                        ],
                      );
                    }
                  //No carrinho
                  case 9:
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: Center(
                          child: ConstsWidget.buildTextTitle(
                              'Confira seu carrinho no menu inicial')

                          //     ConstsWidget.buildCustomButton(
                          //   context,
                          //   ,
                          //   icon: Icons.remove_red_eye_rounded,
                          //   onPressed: () {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => ItensBottom(
                          //               currentTab: 1,
                          //             )));
                          //   },
                          // )
                          ),
                    );
                  //Na fatura
                  case 10:
                    return Center(
                      child: ConstsWidget.buildCustomButton(
                        context,
                        'Confira o Financeiro',
                        icon: Icons.payments_rounded,
                        onPressed: () {
                          logado.navigatorRoute(context, FinanceiroScreen());
                        },
                      ),
                    );
                  default:
                }
              }

              return MeuBoxShadow(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                  ),
                  child: SizedBox(
                    width: size.width * 0.80,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.006),
                            child: ConstsWidget.buildTextTitle(
                                snapshot.data['correspondencias'][index]
                                    ['remetente']['nome_remetente']),
                          ),
                          Row(
                            children: [
                              ConstsWidget.buildTextSubTitle(
                                snapshot.data['correspondencias'][index]
                                    ['descricao'],
                              ),
                              ConstsWidget.buildTextSubTitle(' - $dataCorres'),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01),
                              alignment: Alignment.center,
                              child: indicadorEtapaStatus()),
                          SizedBox(child: statusCorrespondencia()),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
