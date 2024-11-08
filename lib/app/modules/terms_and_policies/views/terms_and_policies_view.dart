import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/terms_and_policies_controller.dart';

class TermsAndPoliciesView extends GetView<TermsAndPoliciesController> {
  final WebViewController controllerWebView;

  TermsAndPoliciesView({
    super.key,
  }) : controllerWebView = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                const CircularProgressIndicator();
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              'https://www.termsfeed.com/live/1673324d-5a79-470e-8540-ce7ca746310a',
            ),
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
              onPressed: Get.back,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
              )),
        ),
        centerTitle: false,
        leadingWidth: 40,
        title: Text(
          'Terms & Policies',
          style: TS.titleSmall,
        ),
      ),
      body: WebViewWidget(controller: controllerWebView),
    );
  }
}
