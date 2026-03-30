import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class ArticlesCard extends StatelessWidget {
  const ArticlesCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    required this.onTap,
  });

  final String title, subtitle, imgUrl;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(
        horizontal: 6,
        vertical: 10,
      ),
      child: CardApp(
        color: white,
        isShadow: true,
        shadows: Shadows.small,
        padding: REdgeInsets.all(8),
        onTap: onTap,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: ListTile(
                minVerticalPadding: 0,
                title: EPadding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    title,
                    style: TS.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: TS.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: Corners.smBorder,
                child: SizedBox(
                  height: 85.h,
                  width: 85.w,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset(.5, .0),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
