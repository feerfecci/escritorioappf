import 'package:escritorioappf/widgets/alert_dialogs/alert_trocar_login.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';

// alertaTrocarUsuario(
//   BuildContext context,
// ) {
//   alertaDialogTrocarLogin(context);
// }

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Widget buildTrocaAppBar(double contHeight, double boxWidth,
    //     {double contWidth = 0.04, double horzPaddin = 0.04}) {
    //   return Container(
    //     height: size.height * contHeight,
    //     width: size.width * contWidth,
    //     margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
    //     padding: EdgeInsets.symmetric(
    //       horizontal: size.width * horzPaddin,
    //       vertical: 1,
    //     ),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //       borderRadius: BorderRadius.circular(29.5),
    //     ),
    //     child: Row(
    //       children: [
    //         Icon(
    //           Icons.business,
    //           color: Colors.blue,
    //         ),
    //         SizedBox(
    //           width: size.width * 0.02,
    //         ),
    //         SizedBox(
    //           width: size.width * boxWidth,
    //           child: Text(
    //             overflow: TextOverflow.ellipsis,
    //             textAlign: TextAlign.left,
    //             logado.razaoSocial,
    //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //           ),
    //         ),
    //         Spacer(),
    //       ],
    //     ),
    //   );
    // }

    return GestureDetector(
        onTap: logado.totalEmpresas != 1
            ? () {
                buildMinhaSnackBar(
                  context,
                  categoria: 'trocar_login',
                );
              }
            : () {},
        onDoubleTap: logado.totalEmpresas == 1
            ? () {}
            : () {
                alertaDialogTrocarLogin(context);
                // alertaTrocarUsuario(context);
              },
        child: ConstsWidget.buildLayout(
          context,
          seMobile: Container(
            height: size.height * 0.05,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(29.5),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0,
                ),
                Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                SizedBox(
                  width: size.width * 0.71,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    logado.razaoSocial,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          seWeb: Container(
            height: size.height * 0.05,
            width: size.width * 0.6,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
            padding: EdgeInsets.symmetric(
              // horizontal: size.width * 0.04,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(29.5),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.01,
                ),
                Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    logado.razaoSocial,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ));
  }
}
