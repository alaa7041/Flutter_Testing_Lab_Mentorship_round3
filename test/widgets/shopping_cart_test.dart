import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('ShoppingCart Widget Tests', () {
    testWidgets('shows "Cart is empty" initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Total Items: 0'), findsOneWidget);
    });

    testWidgets('adds an iPhone item when "Add iPhone" is pressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Total Items: 1'), findsOneWidget);
    });

    testWidgets('clears the cart when "Clear Cart" is pressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      await tester.tap(find.text('Add iPad'));
      await tester.pump();
      expect(find.text('iPad Pro'), findsOneWidget);

      await tester.tap(find.text('Clear Cart'));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('removes an item when delete button is pressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // Add an item first
      await tester.tap(find.text('Add Galaxy'));
      await tester.pump();

      expect(find.text('Samsung Galaxy'), findsOneWidget);

      // Press delete icon
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Cart is empty'), findsOneWidget);
    });

    testWidgets('updates quantity when + and - buttons are pressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShoppingCart(),
          ),
        ),
      );

      // Add item
      await tester.tap(find.text('Add iPhone'));
      await tester.pump();

      // Increase quantity
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);

      // Decrease quantity
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
