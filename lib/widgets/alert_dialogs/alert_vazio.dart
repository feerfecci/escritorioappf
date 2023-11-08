import 'package:flutter/material.dart';
import '../../consts/consts.dart';

// ignore: must_be_immutable
class CampoVazio extends StatefulWidget {
  String? mensagemAvisoVazio;
  CampoVazio({required this.mensagemAvisoVazio, super.key});

  @override
  State<CampoVazio> createState() => CampoVazioState();
}

class CampoVazioState extends State<CampoVazio> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          SizedBox(
              width: size.width * 0.6,
              height: size.height * 0.4,
              child: Image.network('${Consts.arquivoAssets}ico-lupa.png')),
          Text(
            '${widget.mensagemAvisoVazio}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
