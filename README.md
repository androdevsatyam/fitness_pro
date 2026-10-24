# HOMEFIT — phase 1 UI prototype

Flutter public customer experience for the Gurugram home-fitness pilot.

## Run

```sh
flutter pub get
flutter run -d chrome
```

The public app contains customer discovery, profile, authentication and booking flows. Admin, trainer, assessor and support interfaces are deferred and have no entry points in the public app.

## Demo walkthrough

1. Explore the home screen, choose a category and open a trainer profile.
2. Choose **Log in / Register**, enter a name and valid Indian mobile number, request OTP and enter **4589**. No SMS is sent.
3. Choose a service, future date, time and complete home address. Checkout simulates payment without collecting real payment details or charging money.
4. Open My bookings to view the session, cancel, chat, report an issue or review a completed session.

## Mock behavior and phase 2 boundary

`lib/core/state/app_state.dart` is the in-memory mock data adapter. Profiles, registration, booking, reviews, messages, verification and support actions mutate local state only. Restarting the app resets the demo. `tryCreateBooking` validates eligibility, future dates and conflicting sessions with a static 30-minute travel buffer. It does not perform route estimation or reserve inventory across devices.

All payment, earnings, verification and qualification information is illustrative. Remote sample profile photos may require connectivity; home-screen avatars and application fonts work locally. There is no backend, SMS, maps, payment gateway, document upload service or production authentication in this phase.

Phase 2 replaces the mock state boundaries with `/api/v1/` services, real OTP sessions, PostGIS matching, travel feasibility, atomic slot reservations, verification/assessment records, payment reconciliation and notifications. The admin assessor workspace supports mock two-day scoring, a safety gate and reassessment outcomes. Full booking/payment state machine enforcement and production assessment records remain phase 2 work.

## Checks

```sh
flutter analyze
flutter test
flutter build web
```

## Customer experience

The public app uses a warm ivory and forest-green palette, a goal-led home screen, optional discovery filters, simple trainer profiles, and customer bookings and profile views. Feature code is grouped in [lib/features/customer](lib/features/customer/README.md). The home illustration is drawn in Flutter and does not require a remote image service.

Design references: [Kamya Wellness](https://kamyawellness.com/), [Home 1st Fitness](https://home1stfitness.com/) and [Way2Fit](https://www.way2fit.co.in/). Original layouts and copy are used, with no competitor testimonials or performance claims.

## CI/CD

GitHub Actions configuration for checked Flutter web builds and Firebase Hosting deployment is in [.github/workflows/flutter-web.yml](.github/workflows/flutter-web.yml). See [deployment setup](docs/DEPLOYMENT.md) for the required Firebase project ID and GitHub secret. Live deployment remains inactive until those are configured.
