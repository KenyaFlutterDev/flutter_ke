import 'package:mobile/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@riverpod
Raw<GoRouter> router(RouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        name: Home.routeName,
        path: '/',
        builder: (_, __) => const Home(),
      ),
    ],
  );
}
 