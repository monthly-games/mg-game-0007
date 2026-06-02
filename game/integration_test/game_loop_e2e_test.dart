import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> returnToMenu(WidgetTester tester) async {
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('core-fun-loop')), findsOneWidget);
  }

  group('MG-0007 Infinite Jumper - Game Loop E2E', () {
    testWidgets('Core gameplay loop: jumping mechanics and progression', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('game-id')), findsOneWidget);
      expect(find.text('MG-0007'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('primary-loop')), findsOneWidget);
      expect(find.textContaining('Level 1'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('complete-action')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Level 2'), findsOneWidget);
    });

    testWidgets('Achievement system and milestones', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      expect(find.textContaining('achievement'), findsOneWidget);
      expect(find.textContaining('milestone'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('complete-action')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Level 2'), findsOneWidget);
    });

    testWidgets('Mission system and daily challenges', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('daily-quests')));
      await tester.pumpAndSettle();
      expect(find.text('Daily Quests'), findsWidgets);
      expect(find.textContaining('mission'), findsOneWidget);
      await returnToMenu(tester);
    });

    testWidgets('Infinite progression and difficulty scaling', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const ValueKey('complete-action')));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Level 6'), findsOneWidget);
    });

    testWidgets('Full game loop: jump -> achieve -> progress', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('start-game')));
      await tester.pumpAndSettle();

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const ValueKey('complete-action')));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Level 4'), findsOneWidget);
    });
  });
}