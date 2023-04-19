import 'package:flutter/material.dart';
import '../../logado.dart' as logado;

import '../../widgets/cabecalho.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/nested_scroll.dart';
import 'lista_meu_perfil.dart';

class MeuPerfilScreen extends StatefulWidget {
  const MeuPerfilScreen({super.key});

  @override
  State<MeuPerfilScreen> createState() => _MeuPerfilScreenState();
}

class _MeuPerfilScreenState extends State<MeuPerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      endDrawer: CustomDrawer(fundo: '${logado.fundoAssets}perfil.jpg'),
      body: Stack(
        children: [
          MeuNested(
            imageAsset: '${logado.fundoAssets}perfil.jpg',
            context: context,
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                children: [
                  Cabecalho(
                    context: context,
                    titulo: 'Meu Perfil',
                    subTitulo: 'Mantenha seus dados sempre atualizados',
                    child: ListaMeuPerfil(),
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
