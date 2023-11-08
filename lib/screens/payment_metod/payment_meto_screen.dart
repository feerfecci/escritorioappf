import 'dart:convert';

import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/cabecalho.dart';
import 'package:escritorioappf/widgets/custom_drawer.dart';
import 'package:escritorioappf/widgets/nested_scroll.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../../widgets/alert_dialogs/alert_vazio.dart';
import '../../widgets/erro_servidor.dart';
import '../../widgets/shimmer_widget.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

pegarFormaPagamento() async {
  var url = Uri.parse(
      'https://api.iugu.com/v1/customers/${logado.idIugu}/payment_methods?api_token=2D283E3209868E23A3BEA593AF76B115E9DE073AE77AA1C6F6A2DD2E84A59E0A');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

Widget buildInfosPay(BuildContext context,
    {required String titulo, required String conteudo}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
    child: Row(
      children: [
        ConstsWidget.buildTextTitle('$titulo: '),
        ConstsWidget.buildTextSubTitle(conteudo)
      ],
    ),
  );
}

class _PaymentMethodState extends State<PaymentMethod> {
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer:
          CustomDrawer(fundo: "${Consts.fundoAssets}forma-pagamento.jpg"),
      body: Stack(
        children: [
          MeuNested(
            imageAsset: "${Consts.fundoAssets}forma-pagamento.jpg",
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
                    titulo: 'Pagamentos',
                    subTitulo: 'Confira os métodos de pagamento',
                    child: FutureBuilder<dynamic>(
                      future: pegarFormaPagamento(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
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
                              )));
                        } else if (snapshot.hasData == false ||
                            snapshot.hasError == true) {
                          return ErroServidor();
                        } else if (snapshot.data.length == 0) {
                          return CampoVazio(
                              mensagemAvisoVazio:
                                  'Não há métodos de pagamentos');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              NumberFormat formatter = NumberFormat('00');
                              String numeroCartao = snapshot.data[index]['data']
                                  ['display_number'];
                              String bandeira =
                                  snapshot.data[index]['data']['brand'];
                              int mesCard =
                                  snapshot.data[index]['data']['month'];
                              int anoCard =
                                  snapshot.data[index]['data']['year'];
                              String nomeCartao =
                                  snapshot.data[index]['data']['holder_name'];

                              return MeuBoxShadow(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInfosPay(context,
                                      titulo: 'Nome Cartão',
                                      conteudo: nomeCartao),
                                  buildInfosPay(context,
                                      titulo: 'Termina em',
                                      conteudo: numeroCartao.substring(15, 19)),
                                  buildInfosPay(context,
                                      titulo: 'Bandeira', conteudo: bandeira),
                                  buildInfosPay(context,
                                      titulo: 'Vencimento',
                                      conteudo:
                                          '${formatter.format(mesCard)}/$anoCard'),
                                ],
                              ));
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
