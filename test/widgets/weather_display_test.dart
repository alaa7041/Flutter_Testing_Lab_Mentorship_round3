import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart'; // عدلي المسار حسب مشروعك

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('renders dropdown, switch, and refresh button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      expect(find.text('City:'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('shows loading indicator when fetching data', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // في البداية المفروض يحصل loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // بعد انتهاء التحميل (2 ثواني)
      await tester.pump(const Duration(seconds: 2));

      // لازم البيانات تظهر بعدين
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays weather data after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('°C'), findsOneWidget);
    });

    testWidgets('toggles between Celsius and Fahrenheit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));

      // Celsius by default
      expect(find.textContaining('°C'), findsOneWidget);

      // Change switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.textContaining('°F'), findsOneWidget);
    });

    testWidgets('changes city using dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));

      // افتحي القائمة
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // اختاري London
      await tester.tap(find.text('London').last);
      await tester.pump(); // يبدأ اللودينج
      await tester.pump(const Duration(seconds: 2)); // بعد التحميل

      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('handles invalid city safely', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump(const Duration(seconds: 2));

      // غيري المدينة لـ Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump(); // start loading
      await tester.pump(const Duration(seconds: 2));

      // المفروض ميكراشش
      expect(find.byType(Card), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
