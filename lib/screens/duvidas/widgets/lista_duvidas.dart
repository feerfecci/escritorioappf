import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';
import '../../../logado.dart' as logado;
import '../../../widgets/erro_servidor.dart';

class ListaDuvidas extends StatelessWidget {
  const ListaDuvidas({super.key});

  snackBarShow(context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    return buildMinhaSnackBar(context,
        categoria: 'avaliacao', icon: Icons.check_circle_outline_outlined);
  }

  pegaDuvidas() async {
    var url = Uri.parse('${logado.comecoAPI}duvidas/?fn=lista');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  avaliacaoAPI(String gostou, String idDuvida) async {
    var url = Uri.parse(
        '${logado.comecoAPI}duvidas/?fn=ajudou_$gostou&id=$idDuvida&ajuda_$gostou=1');
    //                  /duvidas/?fn=ajudou_  sim  &id=   1     &ajuda_  sim  =1
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: pegaDuvidas(),
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
                          height: size.height * 0.025),
                    ),
                  ],
                ));
              },
            );
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          } else {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data['duvidas'].length,
              itemBuilder: (context, index) {
                // List<String> duvidas = snapshot.data['duvidas'][0];
                final duvida = snapshot.data['duvidas'][index];
                var unescape = HtmlUnescape();

                Widget buildDuvidasListTile(double width) {
                  return Row(children: [
                    SizedBox(
                      width: size.width * width,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: logado.buildTextTitle(
                            duvida['pergunta'],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  // vertical: size.height * 0.021,
                                  horizontal: size.width * 0.020),
                              child: /*Text(
                                  unescape.convert(duvida['resposta']),
                                )*/

                                  Html(
                                data: unescape.convert(duvida['resposta']),
                                style: {
                                  'p': Style(fontSize: FontSize(14)),
                                  'strong': Style(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize(15))
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
                }

                return MeuBoxShadow(
                  child: logado.buildLayout(context,
                      seMobile: buildDuvidasListTile(0.94),
                      seWeb: buildDuvidasListTile(0.65)),
                );
              },
            );
          }
        });
  }
}
