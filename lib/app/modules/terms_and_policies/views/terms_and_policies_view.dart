import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/terms_and_policies_controller.dart';

class TermsAndPoliciesView extends GetView<TermsAndPoliciesController> {
  final WebViewController controllerWebView;

  TermsAndPoliciesView({
    super.key,
  }) : controllerWebView = WebViewController();

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Terms & Policies',
      child: WebViewWidget(
        controller: controllerWebView
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
          ),
      ),
    );
  }
}
