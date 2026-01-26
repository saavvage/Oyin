
fix:
	 dart fix --apply

clean:
	 flutter clean

get:
	 flutter pub get

pods:
	flutter clean && flutter pub get && rm -rf ios/Pods && rm -f ios/Podfile.lock && cd ios && arch -x86_64 pod install --repo-update && cd ..

generate:
	flutter packages pub run build_runner build --delete-conflicting-outputs

nativesplash:
	flutter pub run native_splash:create

build_apk:
	make clean && make get && flutter build apk --release

build_bundle:
	make clean && make get && flutter build appbundle --release -v

build_ios:
	make clean && make get && flutter build ipa --release

localize:
	flutter pub run easy_localization:generate -S "assets/translations" && flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S "assets/translations"

format:
	find . -not -path './.git/*' -not -path '*/.dart_tool/*' -not -path '*/lib/l10n/*' -name "*.dart" ! -name "*.g.dart" ! -name "*.gr.dart" ! -name "*_test.dart" ! -name '*.swagger.*' ! -name '*.config.dart' ! -name '*.chopper.dart' ! -name '*.freezed.dart' | tr '\n' ' ' | xargs  dart format --line-length=120