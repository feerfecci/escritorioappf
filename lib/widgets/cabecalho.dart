import 'package:escritorioappf/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:escritorioappf/logado.dart' as logado;

Widget Cabecalho(
    {double subTitleFontSize = 18,
    double tileFontSize = 34,
    required BuildContext? context,
    FontWeight titleWight = FontWeight.bold,
    FontWeight? subtitleWight,
    required String? titulo,
    required String? subTitulo,
    Color? color,
    dynamic child}) {
  var size = MediaQuery.of(context!).size;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
    child: Wrap(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo!,
                  style: TextStyle(
                    fontSize: tileFontSize,
                    fontWeight: titleWight,
                    color: color ?? Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Text(
                    subTitulo!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: subTitleFontSize,
                      fontWeight: subtitleWight,
                      color: color ?? Colors.white,
                    ),
                  ),
                ),
                SizedBox(child: SearchBar()),
              ],
            ),
          ),
          logado.buildLayout(context,
              seMobile: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  SizedBox(
                    child: child,
                  ),
                ],
              ),
              seWeb: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      child: child,
                    ),
                  ],
                ),
              ))
        ]),
      ],
    ),
  );
}
