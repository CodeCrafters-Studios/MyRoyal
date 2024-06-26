import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:iroyal/base/utils/app_utils.dart';

enum FormLoginValue { email, npwp }

class EditProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;

  RxString personalEmail = ''.obs;
  RxString npwp = ''.obs;

  final GetLoginParams getLoginParams;

  void setEditProfileValue(FormLoginValue key, String value) {
    switch (key) {
      case FormLoginValue.email:
        personalEmail(value);
        AppUtils.logApp(personalEmail.value);
        break;
      case FormLoginValue.npwp:
        npwp(value);
        AppUtils.logApp(npwp.value);
        break;
    }
  }

  Future<void> getParams() async {
    AppUtils.logApp(personalEmail());
    AppUtils.logApp(npwp());

    isLoading(true);
    final r = await getLoginParams(
      ParamsLogin(
        grantType: "password",
        username: username(),
        password: password(),
        clientId: "_a_7w7Lf2aPTFaOketH8QgEvU8rdSegFoJzAY2Gxh_w",
        clientSecret: "yJdF3bVdHd0S7yN4tc6nEhjCa9mbIpeRkAFQWp_d2pQ",
      ),
    );
    r.fold((l) {
      isLoading(false);
      loginState = 'getParamsFailed';
      appDialog.showErrorDialog();
    }, (r) {
      loginState = 'getParamsSuccess';
      loginParams(
        LoginParamsModel(
          grantType: r.grantType,
          username: r.username,
          password: r.password,
          clientId: r.clientId,
          clientSecret: r.clientSecret,
        ),
      );
      login();
    });
  }
}
