icons:
		flutter pub run flutter_launcher_icons:main

splash:
		flutter pub run flutter_native_splash:create

gen:
		dart run build_runner build --delete-conflicting-outputs

fmt:
		dart fix --apply && dart format lib test 

apk:
		flutter build apk --target=lib/main_production.dart -vv

dev-apk:
		flutter build apk --target=lib/main_development.dart -vv

aab:
		flutter build appbundle

base64:
		cat path/to/keystore | openssl base64 | tr -d '\n' | pbcopy

ipa:
		flutter build ipa --target=lib/main_production.dart

sha1:
		keytool -list -v -keystore ~/.android/debug.keystore

rdr:
		flutter run --target=lib/main_development.dart --release

rpr:
		flutter run --target=lib/main_production.dart --release