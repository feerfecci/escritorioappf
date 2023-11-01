// ignore_for_file: unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'package:escritorioappf/logado.dart';
import 'package:escritorioappf/screens/correspondencias/correspondencia_screen.dart';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../Consts/consts_widget.dart';
import '../../../logado.dart' as logado;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../widgets/erro_servidor.dart';

class AlertDialogSolicitacao extends StatefulWidget {
  final int idSolicitacao;
  final int idCorresp;
  final String titulo;
  final String tituloCheckBox;
  const AlertDialogSolicitacao({
    super.key,
    required this.idCorresp,
    required this.idSolicitacao,
    required this.titulo,
    required this.tituloCheckBox,
  });

  @override
  State<AlertDialogSolicitacao> createState() => _AlertDialogSolicitacaoState();
}

solicitar({idCorresp, idSolicitacao}) async {
  final url = Uri.parse(
      '${logado.comecoAPI}correspondencias/index.php?fn=escolhe_tipo_envio&idcorresp=${idCorresp}&tp_envio=${idSolicitacao}&idcliente=${logado.idCliente}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class _AlertDialogSolicitacaoState extends State<AlertDialogSolicitacao> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: mensagemSolicitacao(widget.idCorresp,
            tipoEnvio: widget.idSolicitacao),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                ),
                title: ShimmerWidget.rectangular(
                  height: size.height * 0.01,
                  width: size.width * 0.02,
                ),
                content: SizedBox(
                  width: size.width * 0.98,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerWidget.rectangular(
                        height: size.height * 0.25,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03),
                              child: ShimmerWidget.rectangular(
                                height: size.height * 0.045,
                                width: size.width * 0.2,
                                circular: 5,
                              ),
                            ),
                            ShimmerWidget.rectangular(
                              height: size.height * 0.045,
                              width: size.width * 0.2,
                              circular: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          }
          var menssagemConteudo = snapshot.data["tipo_envio"]["txt_para_modal"];

          bool isChecked = false;
          Widget buildContentSolicitacao(
              {required double paddingAlertHorizontal,
              required double paddingAlertVertical,
              required double paddingBottom}) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.width * paddingAlertHorizontal,
                  vertical: size.height * paddingAlertVertical),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              title: Text(widget.titulo),
              content: SingleChildScrollView(
                child: SizedBox(
                    width: double.maxFinite,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Html(
                              data: menssagemConteudo,
                              style: {"p": Style(fontSize: FontSize(14))},
                            ),
                            CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                title: Text(
                                  widget.tituloCheckBox,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * paddingBottom),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: isChecked
                                      ? () async {
                                          solicitar(
                                              idCorresp: widget.idCorresp,
                                              idSolicitacao:
                                                  widget.idSolicitacao);
                                          Navigator.of(context).pop();
                                          await buildSnackBar(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CorrespondenciasScreen(),
                                              ));
                                        }
                                      : () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isChecked ? Colors.blue : Colors.grey,
                                  ),
                                  child: Text(
                                    "Solicitar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )),
              ),
            );
          }

          return ConstsWidget.buildLayout(
            context,
            seMobile: buildContentSolicitacao(
                paddingAlertHorizontal: 0.05,
                paddingAlertVertical: 0.05,
                paddingBottom: 0.03),
            seWeb: buildContentSolicitacao(
                paddingAlertHorizontal: 0,
                paddingAlertVertical: 0.05,
                paddingBottom: 0.01),
          );
        });
  }

  buildSnackBar(context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    buildMinhaSnackBar(
      context,
      categoria: 'correspondencia_solicitada',
    );
  }
}
