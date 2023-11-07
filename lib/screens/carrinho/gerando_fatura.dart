import 'package:escritorioappf/consts/consts_future.dart';
import 'package:escritorioappf/itens_bottom.dart';
import 'package:escritorioappf/widgets/snackbar/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/erro_servidor.dart';
import '../../widgets/progress_indicator.dart';
import 'carrinho_screen.dart';
import '../../logado.dart' as logado;
import '../../Consts/consts_widget.dart';

class GerandoFatura extends StatefulWidget {
  const GerandoFatura({super.key});

  @override
  State<GerandoFatura> createState() => _GerandoFaturaState();
}

class _GerandoFaturaState extends State<GerandoFatura> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: ConstsFuture.restApi(
            'faturas/?fn=gerar_fatura_corresp&idcliente=${logado.idCliente}&sesscar=${logado.sessCar}'),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: size.height * 0.3,
                width: size.width * 0.6,
                child: CarregandoProgress(corProgress: Colors.blue));
          } else if (snapshot.hasData == false || snapshot.hasError == true) {
            return SizedBox(
                width: 600,
                height: 500,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: ErroServidor(),
                ));
          }
          var qrCode = snapshot.data['pix']['qrcode'];
          var qrcodeText = snapshot.data['pix']['qrcode_text'];
          var total = snapshot.data['total'];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.6,
                    child: Image.network(qrCode),
                  ),
                ),
                RichText(text: TextSpan(children: [TextSpan(text: '$total')])),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total: '),
                      ConstsWidget.buildTextTitle('$total')
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Text(
                    'Você tem até às 23:59 horas para efetuar o pagamento. Após esse horário a fatura será cancelada e as correspondências precisarão ser solicitadas novamente',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Copiar Código Pix',
                    icon: Icons.content_copy_outlined,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: qrcodeText),
                      );
                      Navigator.of(context).pop();

                      buildMinhaSnackBar(
                        context,
                        categoria: 'codigo_pix_copiado',
                      );
                      ConstsFuture.navigatorRemoveUntil(
                              context, ItensBottom(currentTab: 0))
                          .whenComplete(() {
                        setState(() {
                          logado.bolinha == 0;
                        });
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                )
              ],
            ),
          );
        });
  }
}
