import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart'; //1

class LanguageLocalizations {
  static Future<LanguageLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    //2
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return LanguageLocalizations();
    });
  }

  static LanguageLocalizations? of(BuildContext context) {
    return Localizations.of<LanguageLocalizations>(context, LanguageLocalizations);
  }



  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: 'yes action',
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel action',
    );
  }
}

//Locale代理类
class LanguageLocalizationsDelegate
    extends LocalizationsDelegate<LanguageLocalizations> {
  const LanguageLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<LanguageLocalizations> load(Locale locale) {
    //3
    return LanguageLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(LanguageLocalizationsDelegate old) => false;
}