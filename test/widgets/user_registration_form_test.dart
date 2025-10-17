import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart'; 

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('renders all form fields and button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows success message after submitting valid form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Alaa Magdy');
      await tester.enterText(find.byType(TextFormField).at(1), 'alaa@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123!');

      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));


      expect(find.text('Registration successful!'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });
  });
}
