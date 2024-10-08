import 'package:escritorioappf/widgets/nested_scroll.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../widgets/cabecalho.dart';
import '../../widgets/custom_drawer.dart';
import 'lista_faturas.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({Key? key}) : super(key: key);

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: CustomDrawer(
          fundo: '${Consts.fundoAssets}financeiro.jpg',
        ),
        body: MeuNested(
          imageAsset: "${Consts.fundoAssets}financeiro.jpg",
          context: context,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
              // await correspApi();
            },
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Cabecalho(
                      context: context,
                      titulo: 'Faturas',
                      subTitulo: 'Fique por dentro das suas faturas',
                      child: showFaturas(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
