import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';

import '../../screens/financeiro/financeiro_screen.dart';
import '/logado.dart' as logado;

alertaDialogDevendo(context) {
  var size = MediaQuery.of(context).size;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Atenção',
          style: TextStyle(
              fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Html(data: logado.statusCliente, style: {
                  "p": Style(
                    fontSize: FontSize(18),
                  ),
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop(alertaDialogDevendo);
                        },
                        child: Text(
                          'Fechar',
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                      logado.navigatorRoute(context,FinanceiroScreen());
                          
                        },
                        child: Text(
                          'Ver pendencia',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
