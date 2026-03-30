import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class ExpansionTileControllerApp extends StatefulWidget {
  const ExpansionTileControllerApp({
    super.key,
    required this.imgAvatar,
    required this.username,
    required this.departement,
    required this.email,
    required this.children,
  });

  final String imgAvatar;
  final String username;
  final String departement;
  final String email;
  final List<ChildModel> children;

  @override
  State<ExpansionTileControllerApp> createState() =>
      _ExpansionTileControllerAppState();
}

class _ExpansionTileControllerAppState
    extends State<ExpansionTileControllerApp> {
  final ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTileTheme(
          tileColor: white,
          child: Card(
            color: white,
            shadowColor: white,
            elevation: 1,
            margin: REdgeInsets.symmetric(horizontal: 18, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Corners.smRadius,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Corners.smRadius),
              ),
              leading: EPadding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.imgAvatar,
                    style: TS.titleMedium.copyWith(color: primary),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TS.bodyMedium,
                  ),
                  Text(
                    widget.departement,
                    style: TS.bodyMedium,
                  ),
                  Text(
                    widget.email,
                    style: TS.bodyMedium,
                  ),
                ],
              ),
              children: widget.children.map(
                (child) {
                  return ListTileTheme(
                    tileColor: Colors.white,
                    child: EPadding(
                      padding: REdgeInsets.only(left: 40, bottom: 10),
                      child: Card(
                        color: white,
                        shadowColor: white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Corners.smRadius,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          title: Text(child.fullName),
                          subtitle: Text(child.job.workEmail),
                          leading: Text(
                            child.fullName
                                    .split(' ')
                                    .first
                                    .substring(0, 1)
                                    .toUpperCase() +
                                child.fullName
                                    .split(' ')
                                    .last
                                    .substring(0, 1)
                                    .toUpperCase(),
                            style: TS.titleSmall.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        )
      ],
    );
  }
}
