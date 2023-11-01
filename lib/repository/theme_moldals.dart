// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';
import '../../Consts/consts_widget.dart';

light_theme(BuildContext context) {
  return ThemeData(
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.blue, actionTextColor: Colors.white),
    shadowColor: Color.fromARGB(255, 189, 189, 189).withOpacity(0.5),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black38,
      selectedItemColor: Colors.black,
    ),
    cardColor: Colors.white,
    canvasColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.blue),
    colorScheme: ColorScheme.light(primary: Colors.black),
    scaffoldBackgroundColor: logado.kBackPageColor,
    dialogBackgroundColor: logado.kBackPageColor,
    primaryColor: Colors.white,
    textTheme: Theme.of(context)
        .textTheme
        .apply(fontSizeDelta: 1, bodyColor: Colors.black),
  );
}

dark_theme(BuildContext context) {
  return ThemeData(
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.blue, actionTextColor: Colors.black),
    shadowColor: Color.fromARGB(95, 199, 199, 199),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white38,
      selectedItemColor: Colors.white,
    ),
    canvasColor: Colors.blueGrey[600],
    cardColor: Colors.blueGrey[800],
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Colors.blueGrey[1000],
    primaryColor: Colors.blueGrey[900],
    textTheme: Theme.of(context).textTheme.apply(
          fontSizeDelta: 1,
          bodyColor: Colors.white,
        ),
  );
}
