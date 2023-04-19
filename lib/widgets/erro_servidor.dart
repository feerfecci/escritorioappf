import 'package:flutter/material.dart';
import 'package:escritorioappf/logado.dart' as logado;

class ErroServidor extends StatefulWidget {
  const ErroServidor({super.key});

  @override
  State<ErroServidor> createState() => _ErroServidorState();
}

class _ErroServidorState extends State<ErroServidor> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildErroServidorBody() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/erro_servidor.png'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Text(
              'Erro no servidor, volte mais tarde',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        logado.buildLayout(context,
            seMobile: Padding(
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: buildErroServidorBody(),
            ),
            seWeb: Center(
              child: buildErroServidorBody(),
            ))
      ],
    );
  }
}
