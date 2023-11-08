// ignore_for_file: unused_local_variable

library globals;

import 'package:badges/badges.dart' as badge;
import 'package:escritorioappf/widgets/alert_dialogs/alert_vazio.dart';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../../widgets/erro_servidor.dart';
import '../../widgets/shimmer_widget.dart';
import '/screens/notificacoes/lista_notificacao.dart' as notific;

int? quantidadeNaoLida = notific.quantidadeNaoLida;

class ListaNotificacao extends StatefulWidget {
  const ListaNotificacao({super.key});

  @override
  State<ListaNotificacao> createState() => _ListaNotificacaoState();
}

notificacaoApi() async {
  try {
    var url = Uri.parse(
        '${Consts.comecoAPI}notificacoes/?fn=read&idcliente=${logado.idCliente}');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  } on FormatException {
    return ErroServidor();
  }
}

mudaStatus(int idNotific) async {
  var url = Uri.parse(
      '${Consts.comecoAPI}notificacoes/?fn=update&lida=1&id=$idNotific');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

showDescriNotif(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog();
    },
  );
}

class _ListaNotificacaoState extends State<ListaNotificacao> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: notificacaoApi(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return MeuBoxShadow(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.height * 0.02),
                      child: ShimmerWidget.rectangular(
                        height: size.height * 0.025,
                      ),
                    ),
                  ],
                ));
              },
            );
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          } else if (snapshot.data['mensagem'] ==
              "Nenhuma notificação cadastrada!") {
            return CampoVazio(
                mensagemAvisoVazio:
                    'Não há correspondência ainda. Você receberá um email de aviso quando recebermos algo');
          } else {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!['notificacoes'].length,
              itemBuilder: ((context, index) {
                int notificLidas = snapshot.data['notificacoes'][index]['lida'];

                notific.quantidadeNaoLida = snapshot.data['total_nao_lidas'];

                var notif = snapshot.data!['notificacoes'];
                var link = snapshot.data['notificacoes'][index]['link'];
                var datahora = snapshot.data['notificacoes'][index]['datahora'];
                var unescape = HtmlUnescape();
                return StatefulBuilder(builder: (context, snapshot) {
                  Widget buildNotificationTile(double width) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * width,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: badge.Badge(
                              position:
                                  badge.BadgePosition.topEnd(top: 24, end: 2),
                              // toAnimate: false,
                              showBadge: notificLidas == 0 ? true : false,
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return ExpansionTile(
                                  onExpansionChanged: (value) {
                                    mudaStatus(notif[index]['id']);
                                    notificLidas == 1;
                                  },
                                  title: ConstsWidget.buildTextTitle(
                                    unescape.convert(notif[index]['titulo']),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.020),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Html(
                                            data: notif[index]['mensagem'],
                                            style: {
                                              "strong": Style(
                                                  fontWeight: FontWeight.bold)
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.01,
                                                horizontal: size.width * 0.020),
                                            child:
                                                ConstsWidget.buildTextSubTitle(
                                              DateFormat('HH:mm • dd/MM/yyyy')
                                                  .format(
                                                DateTime.parse(datahora),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return MeuBoxShadow(
                    isCardHome: true,
                    child: ConstsWidget.buildLayout(context,
                        seMobile: buildNotificationTile(0.93),
                        seWeb: buildNotificationTile(0.65)),
                  );
                });
              }),
            );
          }
        });
  }
}
