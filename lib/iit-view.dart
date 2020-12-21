import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
class IITView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyWebView(
      src: Strings.of(context).valueOf("Ins"),
    );
  }
}

