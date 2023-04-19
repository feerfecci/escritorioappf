import 'package:escritorioappf/screens/correspondencias/widgets/alert_dialog_geral.dart';
import 'package:flutter/material.dart';

void alertaRetirada(BuildContext context, int idCorresp) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogSolicitacao(
        idSolicitacao: 4,
        titulo: 'Retirada',
        tituloCheckBox: 'Anotarei o protocolo',
        idCorresp: idCorresp,
      );
    },
  );
}

void alertaEscaner(BuildContext context, int idCorresp) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogSolicitacao(
        idSolicitacao: 3,
        titulo: 'Escaner',
        tituloCheckBox: 'Autorizo a Abertura',
        idCorresp: idCorresp,
      );
    },
  );
}

void alertaCorreios(BuildContext context, int idCorresp) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogSolicitacao(
        idSolicitacao: 2,
        titulo: 'Correios',
        tituloCheckBox: 'Autorizo o Envio',
        idCorresp: idCorresp,
      );
    },
  );
}

void alertaDescartar(BuildContext context, int idCorresp) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogSolicitacao(
        idSolicitacao: 5,
        titulo: 'Descarte',
        tituloCheckBox: 'Autorizo o Descarte',
        idCorresp: idCorresp,
      );
    },
  );
}

Widget buildSolicitationButton(BuildContext context,
    {required int idCorresp,
    required String tipo,
    required IconData icon,
    Color? color,
    required void Function()? onTap}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
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
          child: InkWell(
            onTap: onTap,
            child: Column(children: [
              Icon(
                icon,
                color: color != null
                    ? color = color
                    : Theme.of(context).primaryIconTheme.color,
                size: 25,
              ),
              Text(
                tipo,
                style: TextStyle(
                  fontSize: 12,
                  color: color != null
                      ? color = color
                      : Theme.of(context).primaryIconTheme.color,
                ),
              ),
            ]),
          ),
          // ),
        ),
      ],
    ),
  );
}

showIndiceProibido(context, int idCorresp) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Retirada',
        icon: Icons.connect_without_contact_rounded,
        onTap: () {
          alertaRetirada(context, idCorresp);
        },
      ),
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Correios',
        icon: Icons.delivery_dining_sharp,
        onTap: () {
          alertaCorreios(context, idCorresp);
        },
      ),
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Descartar',
        icon: Icons.delete,
        onTap: () {
          alertaDescartar(context, idCorresp);
        },
      ),
    ],
  );
}

showIndicePermitido(context, int idCorresp) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Retirada',
        icon: Icons.connect_without_contact_rounded,
        onTap: () {
          alertaRetirada(context, idCorresp);
        },
      ),
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Escaner',
        icon: Icons.art_track,
        onTap: () {
          alertaEscaner(context, idCorresp);
        },
      ),
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Correios',
        icon: Icons.delivery_dining_sharp,
        onTap: () {
          alertaCorreios(context, idCorresp);
        },
      ),
      buildSolicitationButton(
        context,
        idCorresp: idCorresp,
        tipo: 'Descartar',
        icon: Icons.delete,
        color: Colors.red,
        onTap: () {
          alertaDescartar(context, idCorresp);
        },
      ),
    ],
  );
}
