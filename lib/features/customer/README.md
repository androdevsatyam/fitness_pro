# Customer UI structure

The public app starts in `customer_shell.dart`. It contains no role selector or internal portal routes.

- `home/` — calm introduction, goals, how it works and frequently asked questions
- `discovery/` — trainer search with optional preferences
- `trainers/` — professional profiles, services and qualifications
- `auth/` — mock customer registration and OTP login
- `bookings/` — checkout, confirmation, session history and reviews
- `profile/` — account details, fitness goals and onboarding
- `support/` — booking conversations and issue reporting
- `widgets/` — shared trainer card and original offline studio illustration

The shared palette and theme live in `lib/core/theme/`. `AppState` remains the in-memory mock adapter for phase 1. Thin exports in the original `lib/views/` paths preserve compatibility with deferred prototypes; public feature files use the customer modules directly.

Design references: Kamya Wellness (welcoming wellness introduction), Home 1st Fitness (clear home-training journey), and Way2Fit (personal guidance and local services). HOMEFIT uses original layouts, illustration and copy; competitor claims and testimonials are not reused.
