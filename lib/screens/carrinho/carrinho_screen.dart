// ignore_for_file: unused_import, unused_element
import 'package:escritorioappf/screens/carrinho/gerando_fatura.dart';
import 'package:escritorioappf/screens/carrinho/widgets/loading_carrinho.dart';
import 'package:escritorioappf/widgets/alert_dialogs/alert_vazio.dart';
import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/cabecalho.dart';
import '../../widgets/erro_servidor.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/shimmer_widget.dart';
import 'widgets/lista_carrinho.dart';
import '../../widgets/custom_drawer.dart';
import '../../itens_bottom.dart';
import '../../../logado.dart' as logado;
import 'widgets/lista_carrinho.dart' as carrinho;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

gerarFatura() async {
  var url = Uri.parse(
      '${logado.comecoAPI}faturas/?fn=gerar_fatura_corresp&idcliente=${logado.idCliente}&sesscar=${logado.sessCar}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

utilizarCredito(int creditoCliente, int valorCarrinho) async {
  var url = Uri.parse(
      '${logado.comecoAPI}faturas/index.php?fn=utilizar_credito&idcliente=${logado.idCliente}&sesscar=${logado.sessCar}&credito=$creditoCliente&vtotal=$valorCarrinho');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

var preco = carrinho.totalCarrinho;
showCustomModalBottom(
  BuildContext context,
  child,
) {
  showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) => child,
  );
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            Cabecalho(
              color: Colors.black,
              context: context,
              titulo: 'Carrinho',
              subTitulo: 'Termine aqui as suas compras',
              child: FutureBuilder<dynamic>(
                future: carrinhoApi(),
                builder: (context, snapshot) {
                  var size = MediaQuery.of(context).size;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingCarinhho();
                  } else if (snapshot.hasData == false || snapshot.hasError) {
                    return ErroServidor();
                  } else if (snapshot.data['mensagem'] != "") {
                    return Padding(
                      padding: const EdgeInsets.all(14),
                      child: CampoVazio(
                          mensagemAvisoVazio:
                              'Carrinho vazio. Adicione uma correspondência aqui'),
                    );
                  }

                  var valorCarrinho = snapshot.data!['valor_total_carrinho'];
                  logado.bolinha = snapshot.data["carrinho"].length;

                  Widget buildCarrinhoScreen(
                      double paddingWidth, double paddingHeight) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * paddingWidth,
                          vertical: size.height * paddingHeight),
                      child: logado.buildCustomButton(
                        context,
                        onPressed: () {
                          showCustomModalBottom(
                            context,
                            GerandoFatura(),
                          );
                        },
                        'Gerar Fatura de $valorCarrinho',
                      ),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      ListaCarrinho(),
                      valorCarrinho != 0
                          ? logado.buildLayout(
                              context,
                              seMobile: buildCarrinhoScreen(0.02, 0.01),
                              seWeb: buildCarrinhoScreen(0.19, 0.01),
                            )
                          : Container()
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
