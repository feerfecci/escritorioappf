import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MeuBoxShadow extends StatelessWidget {
  dynamic child;
  bool isCardHome;
  MeuBoxShadow({required this.child, this.isCardHome = false, super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Container(
        // color: Colors.black,
        padding: EdgeInsets.symmetric(
            vertical: isCardHome ? size.height * 0.01 : size.height * 0.01,
            horizontal: isCardHome ? 0 : size.width * 0.02),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(5, 5), // changes position of shadow
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
