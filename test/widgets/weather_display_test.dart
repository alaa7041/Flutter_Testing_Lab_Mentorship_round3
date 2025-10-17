import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('renders dropdown, switch, and refresh button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // تأكد إن العناصر الأساسية ظاهرة
      expect(find.textContaining('City'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('shows loading indicator when fetching data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // في البداية المفروض نلاقي الـ loader
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // بعد التحميل تظهر البيانات
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays weather data after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('°C'), findsOneWidget);
    });

    testWidgets('toggles between Celsius and Fahrenheit',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // تأكد إن الوحدة الحالية °C
      expect(find.textContaining('°C'), findsOneWidget);

      // غيري للـ Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.textContaining('°F'), findsOneWidget);
    });

    testWidgets('changes city using dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // اختاري London من القائمة
      await tester.tap(find.text('London').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // تأكدي إن المدينة اتغيرت
      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('handles invalid city safely', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // اختاري Invalid City
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // تأكدي إن البيانات الافتراضية ظهرت
      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('No data'), findsOneWidget);
    });
  });
}
