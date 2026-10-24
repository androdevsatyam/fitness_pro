import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_pro/core/models/user_model.dart';
import 'package:fitness_pro/core/models/trainer_model.dart';
import 'package:fitness_pro/core/models/booking_model.dart';
import 'package:fitness_pro/core/models/review_model.dart';
import 'package:fitness_pro/core/state/app_state.dart';
import 'package:fitness_pro/views/shared/role_switcher_bar.dart';
import 'package:provider/provider.dart';

void main() {
  group('FitPro State & Business Logic Tests', () {
    test('Initial state loads trainers and seed data', () {
      final state = AppState();
      expect(state.currentRole, UserRole.customer);
      expect(state.trainers.isNotEmpty, true);
      expect(state.bookings.isNotEmpty, true);
      expect(state.platformSettings.platformCommissionPercent, 12.0);
    });

    test('Role switching updates active user and role', () {
      final state = AppState();
      state.setRole(UserRole.trainer);
      expect(state.currentRole, UserRole.trainer);
      expect(state.currentUser.role, UserRole.trainer);

      state.setRole(UserRole.admin);
      expect(state.currentRole, UserRole.admin);
      expect(state.currentUser.role, UserRole.admin);

      state.setRole(UserRole.support);
      expect(state.currentRole, UserRole.support);
      expect(state.currentUser.role, UserRole.support);
    });

    test('Price breakdown calculation applies platform fee, travel fee and 18% GST', () {
      final breakdown = PriceBreakdown.calculate(
        basePrice: 1000.0,
        platformFeePercent: 12.0,
        travelFee: 100.0,
        discountAmount: 200.0,
      );

      // subtotal = (1000 + 100 - 200) = 900
      // platformFee = 1000 * 0.12 = 120
      // taxableAmount = 900 + 120 = 1020
      // gst (18%) = 1020 * 0.18 = 183.6
      // total = 1020 + 183.6 = 1203.6
      expect(breakdown.basePrice, 1000.0);
      expect(breakdown.platformFee, 120.0);
      expect(breakdown.travelFee, 100.0);
      expect(breakdown.discountAmount, 200.0);
      expect(breakdown.gstAmount, closeTo(183.6, 0.01));
      expect(breakdown.totalAmount, closeTo(1203.6, 0.01));
    });

    test('Admin verification queue approval updates trainer status', () {
      final state = AppState();
      final pendingTrainer = state.trainers.firstWhere(
        (t) => t.verificationStatus == VerificationStatus.underReview,
      );

      state.updateTrainerVerification(pendingTrainer.id, VerificationStatus.approved);

      final updated = state.trainers.firstWhere((t) => t.id == pendingTrainer.id);
      expect(updated.verificationStatus, VerificationStatus.approved);
    });

    test('Customer can create booking and add review', () {
      final state = AppState();
      final initialBookingsCount = state.bookings.length;

      final newBooking = BookingModel(
        id: 'BK_TEST_001',
        trainerId: 'trainer_01',
        trainerName: 'Priya Nair',
        trainerPhoto: '',
        customerId: 'user_cust_01',
        customerName: 'Aarav Sharma',
        customerPhone: '+91 9845012345',
        serviceTitle: '1-on-1 Functional Training',
        serviceCategory: 'Functional Training',
        durationMinutes: 60,
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '07:00 AM - 08:00 AM',
        locationAddress: 'Indiranagar, Bengaluru',
        locationType: 'Customer Home',
        price: const PriceBreakdown(
          basePrice: 1200,
          platformFee: 144,
          travelFee: 100,
          discountAmount: 0,
          gstAmount: 259.92,
          totalAmount: 1703.92,
        ),
      );

      state.createBooking(newBooking);
      expect(state.bookings.length, initialBookingsCount + 1);

      // Add verified review
      final newReview = ReviewModel(
        id: 'rev_test_01',
        bookingId: newBooking.id,
        customerName: 'Aarav Sharma',
        customerPhoto: '',
        trainerId: 'trainer_01',
        rating: 5.0,
        comment: 'Outstanding trainer!',
        createdAt: DateTime.now(),
      );
      state.addReview(newReview);
      expect(state.reviews.any((r) => r.id == 'rev_test_01'), true);
    });

    test('Guest exploration allows browsing without registration; registration updates customer state', () {
      final state = AppState();
      // Guest exploration by default
      expect(state.isCustomerRegistered, false);
      expect(state.trainers.isNotEmpty, true);

      // Register customer (e.g. triggered when initiating booking)
      state.registerCustomer(
        name: 'Rohan Verma',
        phone: '9876543210',
        city: 'Bengaluru',
      );
      expect(state.isCustomerRegistered, true);
      expect(state.currentUser.name, 'Rohan Verma');
      expect(state.currentUser.phone, '9876543210');

      // Logout reverts to guest mode
      state.logoutCustomer();
      expect(state.isCustomerRegistered, false);
    });

    test('Trainer, Admin and Support portals enforce authentication gates', () {
      final state = AppState();
      // Initially not authenticated
      expect(state.isTrainerRegistered, false);
      expect(state.isAdminRegistered, false);
      expect(state.isSupportRegistered, false);

      // Trainer authentication cycle
      state.loginTrainer(emailOrPhone: 'priya.trainer@fitpro.in');
      expect(state.isTrainerRegistered, true);
      state.logoutTrainer();
      expect(state.isTrainerRegistered, false);

      // Admin authentication cycle
      state.loginAdmin(email: 'admin.ops@fitpro.in');
      expect(state.isAdminRegistered, true);
      state.logoutAdmin();
      expect(state.isAdminRegistered, false);

      // Support authentication cycle
      state.loginSupport(email: 'neha.support@fitpro.in');
      expect(state.isSupportRegistered, true);
      state.logoutSupport();
      expect(state.isSupportRegistered, false);
    });
  });

  group('UI Role Switcher Widget Test', () {
    testWidgets('RoleSwitcherBar renders Indian market badge and role options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider(
              create: (_) => AppState(),
              child: const RoleSwitcherBar(),
            ),
          ),
        ),
      );

      expect(find.text('Preview role:'), findsOneWidget);
      expect(find.text('Gurugram | INR'), findsOneWidget);
    });
  });
}
