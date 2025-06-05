import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  final Locale locale;

  I18n(this.locale);

  static I18n? of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  static List<String>? packages;

  static const LocalizationsDelegate<I18n> delegate = _I18nDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
    await rootBundle.loadString('assets/${locale.languageCode}.json'); // pastikan pakai .json
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String t(String key, {List<String>? msgParams}) {
    String msg = _localizedStrings[key] ?? key;
    if(msgParams != null){
      msg = getMessage(msg, msgParams);
    }
    return msg;
  }

  String getMessage(String msg, List<String> msgParams) {
    for (int i = 0; i < msgParams.length; i++) {
      msg = msg.replaceAll('{$i}', t(msgParams[i]));
    }
    return msg;
  }
}

class _I18nDelegate extends LocalizationsDelegate<I18n> {
  const _I18nDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) async {
    I18n localizations = I18n(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_I18nDelegate old) => false;
}