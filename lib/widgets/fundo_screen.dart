import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FundoScreen extends StatefulWidget {
  String imageAsset;
  FundoScreen(this.imageAsset, {super.key});

  @override
  State<FundoScreen> createState() => _FundoScreenState();
}

class _FundoScreenState extends State<FundoScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        image: DecorationImage(
            alignment: Alignment.topCenter,
            image: NetworkImage(widget.imageAsset),
            fit: BoxFit.fill),
      ),
    );
  }
}
