import 'package:fitness_pro/features/customer/bookings/booking_flow_view.dart';
import 'package:fitness_pro/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pro/core/state/app_state.dart';
import 'package:fitness_pro/main.dart';

void main() {
  testWidgets(
    'Customer checkout renders on a small phone without pressure timers',
    (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final state = AppState();
      state.registerCustomer(name: 'Aditi', phone: '9876543210');
      final trainer = state.trainers.first;
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            home: BookingFlowView(
              trainer: trainer,
              service: trainer.services.first,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Your session'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  for (final width in [360.0, 600.0, 1280.0]) {
    testWidgets('Customer discovery and optional filters work at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppState(),
          child: const FitProApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        Theme.of(tester.element(find.text('Find your trainer'))).brightness,
        Brightness.light,
      );
      await tester.ensureVisible(find.text('Find your trainer'));
      await tester.tap(find.text('Find your trainer'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Good guidance. At your doorstep.'), findsOneWidget);
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('A few preferences'), findsOneWidget);
      await tester.ensureVisible(find.text('Show trainers'));
      await tester.tap(find.text('Show trainers'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Mock customer registration validates code before signing in', (
    tester,
  ) async {
    final state = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: state, child: const FitProApp()),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField).at(0), 'Aditi');
    await tester.enterText(find.byType(TextField).at(1), '9876543210');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), '0000');
    await tester.tap(find.text('Verify & continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(state.isCustomerRegistered, isFalse);
    await tester.enterText(find.byType(TextField), '4589');
    await tester.tap(find.text('Verify & continue'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(state.isCustomerRegistered, isTrue);
    expect(state.currentUser.name, 'Aditi');
    expect(tester.takeException(), isNull);
  });
}
