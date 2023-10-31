// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:escritorioappf/widgets/cabecalho.dart';
import 'package:escritorioappf/widgets/erro_servidor.dart';
import 'package:flutter/material.dart';
import '../../widgets/box_shadow.dart';
import '../../widgets/shimmer_widget.dart';
import '../meu_perfil/meu_perfil_screen.dart';
import 'widgets/category_card.dart';
import '../correspondencias/correspondencia_screen.dart';
import '../financeiro/financeiro_screen.dart';
import '../notificacoes/lista_notificacao.dart';
import '../notificacoes/notificacao_screen.dart';
import '../../logado.dart' as logado;
import 'package:http/http.dart' as http;

import 'widgets/salas_card.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

contagemNaoPagas() async {
  try {
    var url = Uri.parse(
        // '${logado.comecoAPI}faturas/?fn=qtd_pendente&idcliente=${logado.idIugu}&api_token=${logado.tokenIugu}'
        'https://api.iugu.com/v1/invoices/?customer_id=${logado.idIugu}&api_token=${logado.tokenIugu}&status_filter=pending');
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

mensagemDeAlerta(
  BuildContext context,
) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog();
    },
  );
}

Widget buildLoadingShimmer(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return MeuBoxShadow(
    child: Column(
      children: [
        Spacer(),
        ShimmerWidget.rectangular(
          height: size.height * 0.07,
          width: size.width * 0.15,
        ),
        Spacer(),
        ShimmerWidget.rectangular(
          height: 10,
          width: size.width * 0.25,
        ),
        Spacer(),
      ],
    ),
  );
}

Widget showNotificacaoCategory() {
  return FutureBuilder<dynamic>(
      future: notificacaoApi(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingShimmer(context);
          // Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        quantidadeNaoLida = snapshot.data['total_nao_lidas'];
        return CategoryCard(
          iconApi: '${logado.iconAssets}notificacoes.png',
          title: 'Notificações',
          screen: NotificacaoScreen(),
          contagem: quantidadeNaoLida,
          aparece: quantidadeNaoLida == 0 ? false : true,
        );
      });
}

Widget showFinanceiroCategory() {
  return FutureBuilder<dynamic>(
      future: contagemNaoPagas(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return
              // Center(child: CircularProgressIndicator());
              buildLoadingShimmer(context);
        } else if (snapshot.hasError || snapshot.hasData == false) {
          return Text(snapshot.error.toString());
        }
        int? quantidadePendente = snapshot.data['totalItems'];

        return CategoryCard(
          iconApi: '${logado.iconAssets}financeiro.png',
          title: 'Financeiro',
          screen: FinanceiroScreen(),
          contagem: quantidadePendente,
          aparece: quantidadePendente == 0 || quantidadePendente == null
              ? false
              : true,
        );
      });
}

Widget buildCardsGrid(
    {required int crossAxisCount,
    required double childAspectRatio,
    required double crossAxisSpacing}) {
  return GridView.count(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: crossAxisCount,
    childAspectRatio: childAspectRatio,
    crossAxisSpacing: crossAxisSpacing,
    children: [
      CategoryCard(
        iconApi: '${logado.iconAssets}correspondencias.png',
        title: 'Correspondências',
        screen: CorrespondenciasScreen(),
        contagem: 0,
        aparece: false,
      ),
      CategoryCard(
        iconApi: '${logado.iconAssets}perfil.png',
        title: 'Meu Perfil',
        screen: MeuPerfilScreen(),
        contagem: 0,
        aparece: false,
      ),
      showNotificacaoCategory(),
      showFinanceiroCategory(),
    ],
  );
}

class _HomePrincipalState extends State<HomePrincipal> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    dynamic horarioAgora = TimeOfDay.now().hour;
    var saudacao = "";
    if (horarioAgora >= 00 && horarioAgora < 12) {
      saudacao = "Bom dia";
    } else if (horarioAgora >= 12 && horarioAgora < 18) {
      saudacao = "Boa Tarde";
    } else {
      saudacao = "Boa Noite";
    }

    Widget buildCardAluguel({required double pedding}) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * pedding),
          child: Column(
            children: [
              CardSalas(
                titulo: 'Alugar Sala de Reunião',
                uriImage: '${logado.arquivoAssets}banner-sr.jpg',
                zapzap: 'sr',
              ),
              CardSalas(
                titulo: 'Alugar Sala de Treinamento',
                uriImage: '${logado.arquivoAssets}banner-st.jpg',
                zapzap: 'st',
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ));
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        children: [
          Cabecalho(
            color: Colors.black,
            context: context,
            titulo: '$saudacao',
            titleWight: FontWeight.w500,
            tileFontSize: 18,
            subTitulo: '${logado.nomeSaudacao}',
            subtitleWight: FontWeight.w900,
            subTitleFontSize: 32,
          ),
          logado.buildLayout(
            context,
            seMobile: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: buildCardsGrid(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12),
            ),
            seWeb: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
              child: buildCardsGrid(
                  crossAxisCount: 4, childAspectRatio: 2, crossAxisSpacing: 20),
            ),
          ),
          logado.buildLayout(
            context,
            seMobile: buildCardAluguel(pedding: 0.02),
            seWeb: buildCardAluguel(pedding: 0.12),
          ),
        ],
      ),
    );
  }
}
