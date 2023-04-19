// ignore_for_file: unused_import
import 'package:escritorioappf/widgets/cabecalho.dart';
import 'package:escritorioappf/widgets/fundo_screen.dart';
import 'package:escritorioappf/widgets/nested_scroll.dart';
import 'package:escritorioappf/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'lista_correspondencia.dart';
import '../../widgets/custom_drawer.dart';
import '../../itens_bottom.dart';
import '../../logado.dart' as logado;

class CorrespondenciasScreen extends StatefulWidget {
  const CorrespondenciasScreen({super.key});

  @override
  State<CorrespondenciasScreen> createState() => _CorrespondenciasScreenState();
}

class _CorrespondenciasScreenState extends State<CorrespondenciasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        endDrawer: CustomDrawer(
          fundo: '${logado.fundoAssets}correspondencias.jpg',
        ),
        body: MeuNested(
          imageAsset: "${logado.fundoAssets}correspondencias.jpg",
          context: context,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: [
                Cabecalho(
                  titulo: 'Correspondências',
                  subTitulo: 'Verifique suas correspondências',
                  child: ListaCorresp(),
                  context: context,
                ),
              ],
            ),
          ),
        ));
  }
}
