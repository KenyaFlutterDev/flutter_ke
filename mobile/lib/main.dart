import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/services/error_logger/error_logger.dart';
import 'package:mobile/ui/app/pages/my_app.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await GoogleFonts.pendingFonts([
        GoogleFonts.inter(),
      ]);

      final appRouter = AppRouter();

      runApp(
        ProviderScope(
          child: MyApp(appRouter: appRouter),
        ),
      );
    },
    (error, stackTrace) {
      if (kDebugMode) {
        ErrorLoggerService.instance.logError(
          error,
          message: 'Error in main:runZonedGuarded',
          stackTrace: stackTrace,
        );
      } else {
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }
    },
  );
}
