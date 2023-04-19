import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../logado.dart' as logado;
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoliticaPrivacidade extends StatefulWidget {
  const PoliticaPrivacidade({super.key});

  @override
  State<PoliticaPrivacidade> createState() => _PoliticaPrivacidadeState();
}

politicaApi() async {
  final url = Uri.parse('${logado.comecoAPI}politica_privacidade');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    return null;
  }
}

class _PoliticaPrivacidadeState extends State<PoliticaPrivacidade> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logado.kButtonColor,
      ),
      body: FutureBuilder<dynamic>(
          future: politicaApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError == true || snapshot.hasData == false) {
              return ErroServidor();
            } else {
              var texto = snapshot.data['texto'];
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.04),
                        child: Image(
                          image: NetworkImage(
                              '${logado.arquivoAssets}logo-login-f.png'),
                        ),
                      ),
                      Html(
                        data: texto,
                        style: {
                          'p': Style(fontSize: FontSize(18)),
                          'ul': Style(fontSize: FontSize(18))
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
