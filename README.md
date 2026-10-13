# 🇮🇳 FitPro India - Freelance Fitness Trainer Marketplace

> **"Find a certified fitness professional near you. Train on your schedule. No gym membership or expensive equipment required."**

A multi-platform fitness marketplace prototype connecting clients across India with independent, verified fitness coaches for in-person personal training at **home, apartment society gyms, or nearby parks**.

---

## 🌐 Live Prototype Demonstration

Explore the live UI/UX prototype across **Desktop Web**, **Mobile (iPhone / Android)**, and **Tablet** viewports:

👉 **[https://androdevsatyam.github.io/fitness_pro/](https://androdevsatyam.github.io/fitness_pro/)**

*(Hosted on the `public_prototype` branch via GitHub Pages)*

---

## 📱 Multi-Device Studio Simulator

When running on the web, FitPro India includes an interactive **Device Preview Studio Shell**:
* 🖥️ **Desktop Web Mode**: Full-width, multi-column responsive experience with expanded grids and administrative dashboards.
* 📱 **Mobile Device Mode (iPhone 16 Pro / Android)**: Renders the entire application inside an interactive smartphone frame ($393 \times 852\text{ px}$) complete with dynamic island, status bar, and bottom navigation.
* 📟 **Tablet Mode (iPad Air)**: $820 \times 1180\text{ px}$ responsive layout.
* 🔄 **Device Orientation**: 1-click toggle between Portrait and Landscape modes.
* ⚡ **Flow Switcher**: Quick-jump directly to any screen in the prototype.
* 🎭 **Role Switcher**: Instant role toggle between Customer, Trainer, Administrator, and Support Agent.

---

## 🚀 Key Features Built

### 1. Indian Market Context
* All prices in Indian Rupees (**₹**)
* Indian phone verification (`+91`) with simulated 4-digit OTP
* Default Asia/Kolkata timezone
* Major Indian metros: Bengaluru, Mumbai, Delhi NCR, Hyderabad, Pune
* Local payment flows: UPI (Google Pay, PhonePe, Paytm, BHIM), RuPay/Visa/Mastercard, NetBanking
* Itemized 18% GST calculation

### 2. Multi-Role Architecture
* **Customer**: Discover local trainers, personalized fitness matching quiz, reserve session slots, pay, chat with trainer, leave verified reviews, report issues.
* **Trainer Pro**: Apply and upload accreditation proofs (ACE, ACSM, Yoga Alliance, K11), set hourly rates in ₹, configure travel radius, accept bookings, execute session lifecycle with a **Live Stopwatch Timer**, and track net weekly payouts.
* **Administrator**: Gross Booking Value (GBV) vs Platform Revenue KPIs, **Trainer Verification Queue** (inspect certificates and Aadhaar ID checks), dispute resolution with refund actions, and dynamic platform commission sliders.
* **Support Agent**: Support ticket queue with priority routing and grievance resolution without exposing sensitive credentials.

### 3. Onboarding Journeys
* **Welcome Onboarding Hub**: Interactive value propositions highlighting doorstep fitness, freelance trainer autonomy, and accreditation checks.
* **Customer Goals Quiz**: Primary goals, training styles, session duration (45/60/90m), budget slider, city selection, and limitation notes.
* **Trainer Accreditation Application**: 10-step submission covering profile, certificate numbers, expiry dates, document uploads, Aadhaar screening, and terms acceptance.

### 4. Booking & Slot Hold Engine
* **10-Minute Slot Hold Countdown**: Prevents double-booking during checkout.
* **Transparent Itemized Billing**: Trainer base fee + Travel surcharge + Platform convenience fee (default 12%) - Promo discounts (`FITFIRST`, `HEALTHY10`) + 18% GST.

---

## 🛠️ Technology Stack

* **Frontend**: Flutter 3.35+ (Dart 3.9+)
* **State Management**: Reactive `Provider` with centralized `AppState`
* **Typography**: Plus Jakarta Sans via `google_fonts`
* **Formatting**: `intl` (Indian currency ₹, dates, and times)
* **Design System**: Emerald/Teal energetic fitness palette with Dark Mode theme

---

## 💻 Local Setup & Development

```bash
# 1. Clone repository
git clone https://github.com/androdevsatyam/fitness_pro.git
cd fitness_pro

# 2. Get dependencies
flutter pub get

# 3. Run automated tests
flutter test

# 4. Run on Chrome (Web)
flutter run -d chrome

# 5. Run on connected Android / iOS device
flutter run
```

---

## 📄 License & Ownership

Developed for the FitPro India Freelance Fitness Trainer Marketplace.
© 2026 FitPro India Technologies Pvt. Ltd. All rights reserved.
