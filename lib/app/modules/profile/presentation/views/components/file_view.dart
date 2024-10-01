import 'package:flutter/material.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FileView extends StatelessWidget {
  final String title;
  final String url;
  final WebViewController controllerWebView;

  FileView({
    super.key,
    required this.title,
    required this.url,
  }) : controllerWebView = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Optionally handle loading progress here
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
          ..loadRequest(Uri.parse(url));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TS.titleSmall,
        ),
      ),
      body: WebViewWidget(controller: controllerWebView),
    );
  }
}
