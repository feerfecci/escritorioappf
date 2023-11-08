import 'dart:io';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../Consts/consts_widget.dart';
import 'package:url_launcher/url_launcher.dart';

alertDialogUpdate(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => GestureDetector(
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              title: Text('Atualização disponível',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.025),
                      child: Image(
                        image: NetworkImage(
                            '${Consts.arquivoAssets}logo-login-f.png'),
                      ),
                    ),
                    // Container(
                    //   child: Text(
                    //     'Atualize na sua loja de aplicativo',
                    //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
              actions: [
                ConstsWidget.buildCustomButton(
                  context,
                  'Atualize na sua loja de aplicativo',
                  onPressed: () {
                    if (Platform.isAndroid) {
                      launchUrl(Uri.parse('https://bit.ly/3XFOISA'),
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isIOS) {
                      launchUrl(Uri.parse('https://apple.co/3IakBuM'),
                          mode: LaunchMode.externalApplication);
                    }

                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ));
}
