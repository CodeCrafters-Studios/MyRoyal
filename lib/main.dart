import 'package:MyRoyal/app.dart';
import 'package:MyRoyal/base/config/environment_config.dart';
import 'package:MyRoyal/base/initialization/app_setup.dart';

void main() async => await setupAndRunApp(
      (config) => BaseApp(
        config: config,
      ),
      environment: const EnvironmentConfig.production(),
    );
