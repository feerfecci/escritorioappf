// ignore_for_file: unused_import
import 'package:escritorioappf/widgets/fundo_screen.dart';
import 'package:escritorioappf/widgets/nested_scroll.dart';
import 'package:escritorioappf/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../widgets/cabecalho.dart';
import '../../widgets/custom_drawer.dart';
import 'lista_notificacao.dart';
import '../../itens_bottom.dart';
import '../financeiro/financeiro_screen.dart';
import '../home/home_principal.dart';
import 'package:escritorioappf/logado.dart' as logado;

class NotificacaoScreen extends StatefulWidget {
  const NotificacaoScreen({Key? key}) : super(key: key);

  @override
  State<NotificacaoScreen> createState() => _NotificacaoScreenState();
}

class _NotificacaoScreenState extends State<NotificacaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: CustomDrawer(fundo: '${Consts.fundoAssets}notificacoes.jpg'),
      body: MeuNested(
        imageAsset: '${Consts.fundoAssets}notificacoes.jpg',
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
                    titulo: 'Notificações',
                    subTitulo: 'Veja todas as suas notificações',
                    child: ListaNotificacao(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
