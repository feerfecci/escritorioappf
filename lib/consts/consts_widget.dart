import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'consts.dart';

class ConstsWidget {
  static Widget buildTextTitle(String title,
      {double? fontSize,
      TextAlign? textAlign,
      Color? color,
      int maxLines = 20,
      TextOverflow? overflow,
      FontStyle? fontStyle}) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        overflow: overflow,
        fontSize: fontSize ?? 18,
        fontStyle: fontStyle,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(String title, {TextAlign? textAlign, color}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCachedImage(
    BuildContext context, {
    required String iconApi,
    double? width,
    double? height,
    String? title,
    bool meuWidth = false,
    BorderRadiusGeometry? borderRadius,
  }) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CachedNetworkImage(
          imageUrl: iconApi,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: borderRadius,
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          ),
          height: !meuWidth
              ? height != null
                  ? size.height * height
                  : null
              : height,
          width: !meuWidth
              ? width != null
                  ? size.width * width
                  : null
              : width,
          // fit: BoxFit.fill,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          // placeholder: (context, url) => ShimmerWidget(
          //     // height: SplashScreen.isSmall
          //     //     ? size.height * 0.06
          //     //     : size.height * 0.068,
          //     // width: size.width * 0.15
          //     ),
          errorWidget: (context, url, error) => Image.asset('ico-error.png'),
        )
      ],
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = Consts.kButtonColor,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        fixedSize: Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.borderButton),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * 0.015,
            ),
            icon != null
                ? Icon(size: 18, icon, color: Colors.white)
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  static Widget buildLayout(BuildContext context,
      {required Widget seMobile, required Widget seWeb}) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth < 1000;
      return isMobile ? seMobile : seWeb;
    });
  }
}
