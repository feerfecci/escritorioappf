import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import '../../../Consts/consts_widget.dart';
import '../../../logado.dart' as logado;

class CategoryCard extends StatefulWidget {
  final String iconApi;
  final String title;
  final dynamic screen;
  final dynamic contagem;
  final bool aparece;

  const CategoryCard({
    super.key,
    required this.iconApi,
    required this.title,
    required this.screen,
    required this.contagem,
    required this.aparece,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.contagem;
          logado.navigatorRoute(context, widget.screen);
        });
      },
      child: MeuBoxShadow(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            badge.Badge(
              position: badge.BadgePosition.topEnd(),
              showBadge: widget.aparece,
              // toAnimate: false,
              badgeContent: Text(
                widget.contagem.toString(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              child: ConstsWidget.buildLayout(
                context,
                seMobile: SizedBox(
                    width: size.width * 0.15,
                    height: size.height * 0.075,
                    child: Image.network(
                      widget.iconApi,
                    )),
                seWeb: Image.network(
                  widget.iconApi,
                ),
              ),
            ),
            ConstsWidget.buildTextTitle(
              widget.title,
            ),
          ],
        ),
      ),
    );
  }
}
