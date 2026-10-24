import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pro/core/state/app_state.dart';
import 'package:fitness_pro/core/models/user_model.dart';
import 'package:fitness_pro/main.dart';

void main() {
  test('Assessment safety failure blocks activation despite high scores', () {
    final state = AppState();
    final id = state.trainers.last.id;
    state.saveAssessment(id, 95, 95, false);
    expect(state.assessmentResults[id], contains('Reassessment required'));
    expect(state.trainers.last.verificationStatus.name, 'changesRequested');
    state.saveAssessment(id, 80, 85, true);
    expect(state.trainers.last.verificationStatus.name, 'approved');
  });

  test('Trainer travel preferences remain independent', () {
    final state = AppState();
    state.updateTravelPreference(state.trainers.first.id, true);
    expect(state.trainers.first.openToLongDistance, isTrue);
    expect(state.trainers[1].openToLongDistance, isFalse);
  });
  test('Customer identity survives previewing another role', () {
    final state = AppState();
    state.registerCustomer(name: 'Demo Customer', phone: '9876543210');
    final id = state.currentUser.id;
    state.setRole(UserRole.trainer);
    state.loginTrainer();
    state.setRole(UserRole.customer);
    expect(state.currentUser.id, id);
    expect(state.currentUser.name, 'Demo Customer');
  });

  test('Mock booking rejects guests and overlapping travel buffers', () {
    final state = AppState();
    final booking = state.bookings.first;
    expect(state.tryCreateBooking(booking), contains('sign in'));
    state.registerCustomer(name: 'Demo', phone: '9876543210');
    expect(
      state.tryCreateBooking(booking.copyWith(id: 'duplicate')),
      contains('overlaps'),
    );
    final later = booking.copyWith(
      id: 'later',
      scheduledDate: booking.scheduledDate.add(const Duration(days: 3)),
    );
    expect(state.tryCreateBooking(later), isNull);
    expect(state.bookings.first.id, 'later');
  });

  for (final width in [390.0, 1280.0]) {
    testWidgets('HOMEFIT home and navigation render at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
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
      expect(find.text('A little movement.\nA little more you.'), findsOneWidget);
      expect(find.text('Find your trainer'), findsOneWidget);
      expect(find.text('Preview role:'), findsNothing);
      expect(find.byType(DropdownButton<UserRole>), findsNothing);
      expect(find.text('Help people feel their best.'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
