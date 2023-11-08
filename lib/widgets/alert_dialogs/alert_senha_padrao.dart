import 'package:flutter/material.dart';
import '../../Consts/consts_future.dart';
import '../../screens/meu_perfil/meu_perfil_screen.dart';

alertDialogSenhaPadrao(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            title: Text('Sua senha é padrão!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Atualize na sua senha no menu Meu Perfil\nTroque a senha para mais segurança em seu acesso',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    ConstsFuture.navigatorPageRoute(context, MeuPerfilScreen());
                  },
                  child: Text('Ir para Meu Perfil')),
            ],
          ));
}
