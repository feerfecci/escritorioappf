import 'package:flutter/material.dart';
import '../Consts/Consts.dart';

class BanerCard extends StatefulWidget {
  final String baner;
  const BanerCard(this.baner, {super.key});

  @override
  State<BanerCard> createState() => _BanerCardState();
}

class _BanerCardState extends State<BanerCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              '${Consts.arquivoAssets}${widget.baner}',
            ),
            fit: BoxFit.fill),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
