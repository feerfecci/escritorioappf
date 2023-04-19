import 'package:escritorioappf/widgets/box_shadow.dart';
import 'package:escritorioappf/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardSalas extends StatefulWidget {
  final String titulo;
  final String uriImage;
  final String zapzap;
  const CardSalas({
    super.key,
    required this.titulo,
    required this.uriImage,
    required this.zapzap,
  });

  @override
  State<CardSalas> createState() => _CardSalasState();
}

lauchWhatsapp({String linkBit = ''}) async {
  final zapzap = Uri.parse(linkBit);
  await launchUrl(Uri.parse(zapzap.toString()),
      mode: LaunchMode.externalApplication);
}

class _CardSalasState extends State<CardSalas> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MeuBoxShadow(
              child: ShimmerWidget.rectangular(
                height: size.height * 0.28,
                width: size.width * 0.98,
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  widget.titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  lauchWhatsapp(
                    linkBit: widget.zapzap == 'sr'
                        ? 'https://bit.ly/3YO8goa'
                        : 'https://bit.ly/3JexpTf',
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.uriImage,
                    width: size.width * 0.98,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
