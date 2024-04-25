import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';

class ExpansionTileControllerApp extends StatefulWidget {
  const ExpansionTileControllerApp({super.key});

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
                leading: const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text('Avatar'),
                ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Example Username',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Example Departement',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '0123456789',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 20,
                      itemBuilder: (_, __) {
                        return const ListTileTheme(
                          tileColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Card(
                              child: ListTile(
                                title: Text('Inner Tile'),
                                subtitle: Text('subtitle'),
                                leading: FlutterLogo(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
