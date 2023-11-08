import 'package:escritorioappf/screens/duvidas/lista_duvidas.dart';
import 'package:flutter/material.dart';

import '../../widgets/cabecalho.dart';

class DuvidasScreen extends StatefulWidget {
  const DuvidasScreen({super.key});

  @override
  State<DuvidasScreen> createState() => _DuvidasScreenState();
}

class _DuvidasScreenState extends State<DuvidasScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        children: [
          Cabecalho(
              context: context,
              titulo: 'Dúvidas',
              subTitulo: 'Confira as principais dúvidas',
              child: ListaDuvidas(),
              color: Colors.black),
        ],
      ),
    );
  }
}
