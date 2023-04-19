import 'package:flutter/material.dart';
import '../../../widgets/box_shadow.dart';
import '../../../widgets/shimmer_widget.dart';

class LoadingCarinhho extends StatefulWidget {
  const LoadingCarinhho({super.key});

  @override
  State<LoadingCarinhho> createState() => _LoadingCarinhhoState();
}

class _LoadingCarinhhoState extends State<LoadingCarinhho> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildListTileLoading(
        {double heightPadding = 0.01,
        double height = 0.01,
        double width = double.infinity}) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * heightPadding,
        ),
        child: ShimmerWidget.rectangular(
          height: size.height * height,
          width: size.width * width,
        ),
      );
    }

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01,
          ),
          child: MeuBoxShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildListTileLoading(width: 0.5),
              buildListTileLoading(width: 0.6),
              buildListTileLoading(width: 0.2),
              buildListTileLoading(width: 0.3),
              buildListTileLoading(width: 0.4),
            ],
          ))),
    );
  }
}
