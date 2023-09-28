import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/auth/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerSingleton<AuthRepository>(
    AuthRepository(
      googleSignIn: GoogleSignIn(),
      supabaseAuth: Supabase.instance.client.auth,
    ),
  );
}
