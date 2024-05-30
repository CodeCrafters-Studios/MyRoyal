import 'package:iroyal/app.dart';
import 'package:iroyal/base/config/environment_config.dart';
import 'package:iroyal/base/initialization/app_setup.dart';

void main() async => await setupAndRunApp(
      (config) => BaseApp(
        config: config,
      ),
      environment: const EnvironmentConfig.production(),
    );
