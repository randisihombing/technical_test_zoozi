import 'package:flutter/cupertino.dart';

import '../helper/i18n.dart';

class RText extends StatelessWidget {

  const RText(
      this.text,
      {
        super.key,
        this.msgParams,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final List<String>? msgParams;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final localized = I18n.of(context)?.t(text, msgParams: msgParams) ?? text;
    return Text(
      localized,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
