import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

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
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.imgAvatar,
                      style: TS.titleMedium.copyWith(color: primaryColor),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.departement,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                children: widget.children.map((child) {
                  return ListTileTheme(
                    tileColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Card(
                        child: ListTile(
                          title: Text(child.fullName),
                          subtitle: Text(child.job.department),
                          leading: const FlutterLogo(),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
