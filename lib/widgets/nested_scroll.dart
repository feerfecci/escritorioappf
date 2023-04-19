import 'package:escritorioappf/widgets/fundo_screen.dart';
import 'package:flutter/material.dart';
import '../../logado.dart' as logado;

Widget MeuNested({
  required String imageAsset,
  required BuildContext? context,
  required dynamic body,
  dynamic Function()? onRefresh,
  Widget? landing,
}) {
  return StatefulBuilder(builder: (context, setState) {
    Widget buildNastedViews(double toolbarHeight) {
      return NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: landing,
              toolbarHeight: toolbarHeight,
              backgroundColor: Colors.transparent,
              pinned: true,
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            onRefresh;
          },
          child: body,
        ),
      );
    }

    return Stack(
      children: [
        FundoScreen(imageAsset),
        logado.buildLayout(context,
            seMobile: buildNastedViews(52), seWeb: buildNastedViews(80)),
      ],
    );
  });
}
