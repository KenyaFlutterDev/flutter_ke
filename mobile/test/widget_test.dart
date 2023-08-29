import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/global/providers/supabase_provider.dart';
import 'package:mobile/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group(
    'General widget tests',
    () {
      late ProviderContainer providerContainer;

      setUp(() {
        providerContainer = ProviderContainer(
          overrides: [supabaseProvider.overrideWithValue(FakeSupabase())],
        );
      });

      tearDown(() => providerContainer.dispose());

      testWidgets(
        'Loads Home Page',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            ProviderScope(
              parent: providerContainer,
              child: const App(),
            ),
          );

          expect(find.byType(Home), findsOneWidget);
        },
      );
    },
  );
}

class FakeSupabase extends Fake implements Supabase {}
