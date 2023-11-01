import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../Consts/consts_widget.dart';
import 'alert_vazio.dart';
import '../erro_servidor.dart';
import '../progress_indicator.dart';
import '/logado.dart' as logado;

alertaDialogAviso(BuildContext context) {
  apiAvisos() async {
    var url = Uri.parse(
        '${logado.comecoAPI}avisos-diversos/index.php?fn=mostrarAviso');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  showDialog(
    context: context,
    builder: (context) => FutureBuilder<dynamic>(
        future: apiAvisos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CarregandoProgress(corProgress: Colors.blue);
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return ErroServidor();
          } else if (snapshot.data['mensagem'] ==
              "Nenhuma correspondência localizada!") {
            return CampoVazio(mensagemAvisoVazio: snapshot.data['mensagem']);
          }
          var size = MediaQuery.of(context).size;
          var titulo = snapshot.data['titulo'];
          var subtitulo = snapshot.data!['subtitulo'];
          var texto = snapshot.data!['texto'];
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            title: ConstsWidget.buildTextTitle('$titulo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: ConstsWidget.buildTextSubTitle(subtitulo),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Container(
                    child: ConstsWidget.buildTextSubTitle(texto),
                  ),
                ),
              ],
            ),
            actions: [
              ConstsWidget.buildCustomButton(context, 'Fechar', onPressed: () {
                Navigator.pop(context);
              })
            ],
          );
        }),
  );
}
