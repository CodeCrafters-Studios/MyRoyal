import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.imgUrl,
    required this.onTap,
  });

  final String imgUrl;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      color: white,
      isShadow: false,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: Corners.smBorder,
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: FractionalOffset(.5, .0),
          child: CachedNetworkImage(
            imageUrl: imgUrl,
          ),
        ),
      ),
    );
  }
}
