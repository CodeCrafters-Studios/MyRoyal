import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/login/presentation/views/components/animated_toggle.dart';

class AuthHeader extends StatefulWidget {
  const AuthHeader({super.key});

  @override
  State<AuthHeader> createState() => _AuthHeaderState();
}

class _AuthHeaderState extends State<AuthHeader> {
  int _toggleValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedToggle(
          values: const ['LDAP', 'I-ROYAL'],
          onToggleCallback: (value) {
            setState(() {
              _toggleValue = value;
            });
          },
        ),
        _toggleValue == 0
            ? const Text('baseUrl : http://staging.hrms.ras.co.id')
            : const Text('baseUrl : http://api.ras.co.id/'),
        300.verticalSpace,
      ],
    );
  }
}
