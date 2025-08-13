# flutter_bloc_template
`dart run intl_translation:extract_to_arb --output-dir=i10n-arb lib/i18n/localization_intl.dart`

`dart run intl_translation:generate_from_arb --output-dir=lib/i18n --no-use-deferred-loading lib/i18n/localization_intl.dart i10n-arb/intl_*.arb`
### 编译为apk
`flutter build apk --obfuscate --split-debug-info=C:\Users\keep\Desktop\flutter_bloc_template\build\app --release`