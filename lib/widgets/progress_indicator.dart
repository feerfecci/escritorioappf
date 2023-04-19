import 'package:flutter/material.dart';

class CarregandoProgress extends StatefulWidget {
  final Color corProgress;
  const CarregandoProgress({required this.corProgress, super.key});

  @override
  State<CarregandoProgress> createState() => CarregandoProgressState();
}

class CarregandoProgressState extends State<CarregandoProgress> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.25),
      child: Center(
        child: CircularProgressIndicator(
          color: widget.corProgress,
          backgroundColor: Color.fromARGB(255, 236, 236, 236),
        ),
      ),
    );
  }
}
