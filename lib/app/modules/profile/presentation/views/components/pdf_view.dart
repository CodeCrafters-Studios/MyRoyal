import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:MyRoyal/base/design/styles.dart';

class PDFView extends StatelessWidget {
  const PDFView({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TS.titleSmall,
        ),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(
            child: Text(
          '$progress %',
          style: TS.titleMedium,
        )),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
