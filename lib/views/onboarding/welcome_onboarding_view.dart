import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'customer_onboarding_view.dart';
import 'trainer_onboarding_view.dart';
import '../public/landing_page.dart';

class WelcomeOnboardingView extends StatefulWidget {
  const WelcomeOnboardingView({super.key});

  @override
  State<WelcomeOnboardingView> createState() => _WelcomeOnboardingViewState();
}

class _WelcomeOnboardingViewState extends State<WelcomeOnboardingView> {
  int _activeSlide = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'badge': 'Doorstep Personal Training',
      'title': 'Certified Fitness Coaches at Your Doorstep',
      'subtitle':
          'No crowded gyms or costly annual subscriptions. Train in your living room, apartment society clubhouse, or nearby park with certified trainers who bring all equipment.',
      'icon': Icons.fitness_center,
      'stats': '100% Doorstep • Sanitized Gear',
    },
    {
      'badge': 'Independent Freelance Network',
      'title': 'Empowering Independent Fitness Trainers',
      'subtitle':
          'Trainers set their own hourly rates in INR (₹), their travel radius, and flexible working hours. Keep 85-90% of your earnings with weekly automated bank transfers.',
      'icon': Icons.sports_gymnastics,
      'stats': 'Keep 85-90% • Instant Payouts',
    },
    {
      'badge': 'Trust & Verification Standards',
      'title': '100% Vetted Credentials & Indian ID Verification',
      'subtitle':
          'Every trainer undergoes rigorous accreditation validation (ACE, ACSM, Yoga Alliance, K11) and Aadhaar/PAN identity screening before accepting clients.',
      'icon': Icons.verified_user,
      'stats': 'Aadhaar Verified • Accredited Pros',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  children: [
                    // Brand Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'HOMEFIT',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: ' India',
                                style: TextStyle(color: AppColors.primaryLight),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Text(
                            '🇮🇳 INR (₹)',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Interactive Value Proposition Slider Card
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(isDesktop ? 36 : 24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                _slides[_activeSlide]['badge'],
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            Icon(
                              _slides[_activeSlide]['icon'] as IconData,
                              size: 48,
                              color: AppColors.accent,
                            ),
                            const SizedBox(height: 16),

                            Text(
                              _slides[_activeSlide]['title'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop ? 26 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              _slides[_activeSlide]['subtitle'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 13,
                                color: AppColors.textDarkSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDarkCard,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.borderDark),
                              ),
                              child: Text(
                                _slides[_activeSlide]['stats'] as String,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Slide indicator dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_slides.length, (idx) {
                                final isCur = _activeSlide == idx;
                                return InkWell(
                                  onTap: () =>
                                      setState(() => _activeSlide = idx),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: isCur ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isCur
                                          ? AppColors.primaryLight
                                          : AppColors.borderDark,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Role Onboarding Choice Cards
                    Text(
                      'Choose Your Journey to Get Started',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    isDesktop
                        ? Row(
                            children: [
                              Expanded(
                                child: _buildChoiceCard(
                                  title: 'I Want To Train (Customer)',
                                  desc:
                                      'Complete our 1-minute fitness questionnaire, set your budget & goals, and receive personalized trainer matches.',
                                  badge: 'For Fitness Seekers',
                                  icon: Icons.person_add_alt_1,
                                  buttonLabel: 'Start Customer Onboarding',
                                  color: AppColors.primary,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CustomerOnboardingView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildChoiceCard(
                                  title: 'I am a Trainer (Apply Pro)',
                                  desc:
                                      'Submit your fitness certifications, set your session price in INR, choose your travel radius, and apply for verification.',
                                  badge: 'For Certified Coaches',
                                  icon: Icons.sports_kabaddi,
                                  buttonLabel: 'Start Trainer Application',
                                  color: AppColors.accent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const TrainerOnboardingView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildChoiceCard(
                                title: 'I Want To Train (Customer)',
                                desc:
                                    'Complete our 1-minute fitness questionnaire, set your budget & goals, and receive personalized trainer matches.',
                                badge: 'For Fitness Seekers',
                                icon: Icons.person_add_alt_1,
                                buttonLabel: 'Start Customer Onboarding',
                                color: AppColors.primary,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CustomerOnboardingView(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildChoiceCard(
                                title: 'I am a Trainer (Apply Pro)',
                                desc:
                                    'Submit your fitness certifications, set your session price in INR, choose your travel radius, and apply for verification.',
                                badge: 'For Certified Coaches',
                                icon: Icons.sports_kabaddi,
                                buttonLabel: 'Start Trainer Application',
                                color: AppColors.accent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const TrainerOnboardingView(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),

                    // Skip / Explore directly CTA
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandingPage(onExploreClick: () {}),
                          ),
                        );
                      },
                      icon: const Text(
                        'Or explore marketplace directly without onboarding',
                      ),
                      label: const Icon(Icons.arrow_forward, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required String title,
    required String desc,
    required String badge,
    required IconData icon,
    required String buttonLabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDarkSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: Text(buttonLabel, style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
