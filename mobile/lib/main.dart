import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/global/providers/supabase_provider.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load();

  final supabaseURL = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON'];

  final supabase = await Supabase.initialize(
    url: supabaseURL!,
    anonKey: supabaseAnonKey!,
  );

  setupLocator();

  runApp(
    ProviderScope(
      overrides: [supabaseProvider.overrideWithValue(supabase)],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(routerConfig: router);
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Flutter Ke')),
    );
  }
}
