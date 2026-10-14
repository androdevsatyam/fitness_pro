import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import 'trainer_search_view.dart';
import 'trainer_profile_view.dart';
import '../onboarding/trainer_onboarding_view.dart';
import '../onboarding/customer_onboarding_view.dart';
import '../auth/customer_auth_dialog.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback onExploreClick;
  const LandingPage({super.key, required this.onExploreClick});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = 'Bengaluru';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'title': 'All', 'icon': Icons.apps, 'count': '250+'},
    {'title': 'Functional Training', 'icon': Icons.fitness_center, 'count': '85'},
    {'title': 'Yoga & Mindfulness', 'icon': Icons.self_improvement, 'count': '62'},
    {'title': 'Calisthenics & Bodyweight', 'icon': Icons.sports_gymnastics, 'count': '40'},
    {'title': 'Women\'s Fitness', 'icon': Icons.pregnant_woman, 'count': '35'},
    {'title': 'Mobility & Rehab', 'icon': Icons.accessibility_new, 'count': '28'},
    {'title': 'Senior Fitness', 'icon': Icons.elderly, 'count': '22'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(context, state, isDesktop),
            _buildCategorySection(context, state),
            _buildFeaturedTrainersSection(context, state),
            _buildHowItWorksSection(context, isDesktop),
            _buildTrustSafetySection(context, isDesktop),
            _buildBecomeTrainerCta(context, isDesktop),
            _buildFaqSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGuestBanner(BuildContext context, AppState state, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                state.isCustomerRegistered ? Icons.verified_user : Icons.explore_outlined,
                color: state.isCustomerRegistered ? AppColors.accent : AppColors.primaryLight,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  state.isCustomerRegistered
                      ? 'Logged in as ${state.currentUser.name} (+91 ${state.currentUser.phone})'
                      : 'Guest Mode: Explore trainers, credentials & reviews freely. Registration required when booking.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDarkSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!state.isCustomerRegistered)
                ElevatedButton.icon(
                  onPressed: () {
                    CustomerAuthDialog.show(
                      context,
                      onSuccess: () => setState(() {}),
                    );
                  },
                  icon: const Icon(Icons.login, size: 14),
                  label: const Text('Sign In / Register', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    state.logoutCustomer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out of Customer account')),
                    );
                  },
                  icon: const Icon(Icons.logout, size: 14, color: AppColors.error),
                  label: const Text('Log Out', style: TextStyle(fontSize: 12, color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainerOnboardingView()),
                  );
                },
                icon: const Icon(Icons.sports_gymnastics, size: 14, color: AppColors.accent),
                label: const Text('Become a Trainer', style: TextStyle(fontSize: 12, color: AppColors.accent)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  side: const BorderSide(color: AppColors.accent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AppState state, bool isDesktop) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        border: Border(bottom: BorderSide(color: AppColors.borderDark)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 20,
        vertical: isDesktop ? 40 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // Top Guest Banner & Registration Bar
              _buildTopGuestBanner(context, state, isDesktop),
              const SizedBox(height: 24),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: AppColors.primaryLight, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'India\'s 1st Verified Freelance Trainer Marketplace',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Find a certified fitness professional near you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 44 : 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              Text(
                'Train at your home, apartment society gym, or nearby park on your schedule.\nNo crowded gyms. No expensive annual memberships. 100% independent verified trainers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 15,
                  color: AppColors.textDarkSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Prominent Search Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderDark),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildSearchInputField(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildCityDropdown(),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              _triggerSearch(state);
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Find Trainers'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildSearchInputField(),
                          const SizedBox(height: 12),
                          _buildCityDropdown(),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _triggerSearch(state);
                              },
                              icon: const Icon(Icons.search),
                              label: const Text('Find Trainers Near Me'),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              // Quick action buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomerOnboardingView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome, color: AppColors.accent),
                    label: const Text('Personalized Match Quiz (1 Min)'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TrainerOnboardingView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.sports_kabaddi, color: AppColors.primaryLight),
                    label: const Text('Become a Trainer (Apply)'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInputField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Workout style, area, or trainer name...',
        prefixIcon: Icon(Icons.search, color: AppColors.primaryLight),
      ),
      onSubmitted: (_) {
        _triggerSearch(context.read<AppState>());
      },
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.location_on, color: AppColors.accent),
      ),
      dropdownColor: AppColors.surfaceDark,
      items: const [
        DropdownMenuItem(value: 'All', child: Text('All India Cities')),
        DropdownMenuItem(value: 'Bengaluru', child: Text('Bengaluru, KA')),
        DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai, MH')),
        DropdownMenuItem(value: 'Delhi NCR', child: Text('Delhi NCR')),
        DropdownMenuItem(value: 'Hyderabad', child: Text('Hyderabad, TS')),
        DropdownMenuItem(value: 'Pune', child: Text('Pune, MH')),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedCity = val;
          });
        }
      },
    );
  }

  void _triggerSearch(AppState state) {
    state.updateSearchFilters(
      query: _searchController.text.trim(),
      city: _selectedCity,
      category: _selectedCategory,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TrainerSearchView()),
    );
  }

  Widget _buildCategorySection(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore By Workout Style',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      state.updateSearchFilters(category: 'All');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TrainerSearchView()),
                      );
                    },
                    icon: const Text('View All Categories'),
                    label: const Icon(Icons.arrow_forward, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['title'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat['title'] as String;
                        });
                        state.updateSearchFilters(category: cat['title'] as String);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TrainerSearchView()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryLight : AppColors.borderDark,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(cat['icon'] as IconData,
                                    color: isSelected ? AppColors.primaryLight : Colors.white70,
                                    size: 24),
                                const Spacer(),
                                Text(
                                  cat['count'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textDarkMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              cat['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedTrainersSection(BuildContext context, AppState state) {
    final trainers = state.trainers.where((t) => t.verificationStatus == VerificationStatus.approved).toList();
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      color: AppColors.surfaceDark.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Top-Rated Verified Fitness Coaches',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '100% vetted certifications, background checked, and ready to train at your doorstep.',
                        style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
                      ),
                    ],
                  ),
                  if (isDesktop)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TrainerSearchView()),
                        );
                      },
                      child: const Text('Browse All Trainers'),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Grid of trainers
              LayoutBuilder(builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 600
                        ? 2
                        : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trainers.length.clamp(0, 3),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, idx) {
                    final trainer = trainers[idx];
                    return _buildTrainerCard(context, trainer);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainerCard(BuildContext context, TrainerModel trainer) {
    final startingPrice = trainer.services.isNotEmpty
        ? trainer.services.map((s) => s.priceInr).reduce((a, b) => a < b ? a : b)
        : 1000.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo & Verified Badge
          Stack(
            children: [
              Image.network(
                trainer.photoUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 170,
                  color: AppColors.surfaceDarkCard,
                  child: const Center(
                    child: Icon(Icons.fitness_center, size: 48, color: AppColors.primaryLight),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent.withOpacity(0.8)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.accent, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Verified Pro',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.accentGold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${trainer.rating} (${trainer.reviewCount})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainer.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trainer.headline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // City & Travel radius
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textDarkMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${trainer.city} (Within ${trainer.maxTravelRadiusKm.toInt()} km)',
                      style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Next slot
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      'Next slot: ${trainer.nextAvailableSlot}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Pricing & CTA Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Starting at',
                            style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted),
                          ),
                          Text(
                            '${Formatters.formatINR(startingPrice)}/session',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrainerProfileView(trainer: trainer),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('View & Book', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'How FitPro India Works',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A seamless experience for both fitness seekers and independent trainers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textDarkSecondary),
              ),
              const SizedBox(height: 36),

              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildStepItem('1', 'Find & Filter Trainers', 'Explore certified trainers in your Indian city. Filter by workout style, budget, travel radius, and verified reviews.', Icons.search)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStepItem('2', 'Book Your Preferred Slot', 'Choose your training location: your living room, society clubhouse gym, or local park. Reserve with secure slot locking.', Icons.event_available)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildStepItem('3', 'Train In-Person & Pay', 'Your trainer brings necessary equipment and guides your 1-on-1 session. Pay seamlessly via UPI, Cards, or NetBanking.', Icons.check_circle_outline)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildStepItem('1', 'Find & Filter Trainers', 'Explore certified trainers in your Indian city. Filter by workout style, budget, travel radius, and verified reviews.', Icons.search),
                        const SizedBox(height: 20),
                        _buildStepItem('2', 'Book Your Preferred Slot', 'Choose your training location: your living room, society clubhouse gym, or local park. Reserve with secure slot locking.', Icons.event_available),
                        const SizedBox(height: 20),
                        _buildStepItem('3', 'Train In-Person & Pay', 'Your trainer brings necessary equipment and guides your 1-on-1 session. Pay seamlessly via UPI, Cards, or NetBanking.', Icons.check_circle_outline),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String step, String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Icon(icon, color: AppColors.primaryLight, size: 24),
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
        ],
      ),
    );
  }

  Widget _buildTrustSafetySection(BuildContext context, bool isDesktop) {
    return Container(
      color: const Color(0xFF0C1425),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Icon(Icons.shield_outlined, color: AppColors.accent, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Trust, Safety & Verification Standards',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'We enforce uncompromising verification for every freelance trainer listed on our platform.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildTrustPill('📜 100% Verified Certifications (ACE, ACSM, Yoga Alliance, K11)'),
                  _buildTrustPill('🪪 Government ID & Aadhaar/PAN Verification'),
                  _buildTrustPill('⭐ Authentic Reviews From Verified Bookings Only'),
                  _buildTrustPill('🔒 Encrypted In-App Chat — Personal Numbers Kept Private'),
                  _buildTrustPill('🚨 Emergency SOS Guidance & Trusted Contact Sharing'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBecomeTrainerCta(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : 24,
              vertical: isDesktop ? 40 : 28,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF064E3B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you a Certified Fitness Trainer?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Join India\'s leading freelance network. Set your own session prices, your working hours, and your travel radius. Keep 85-90% of your earnings with instant weekly payouts.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TrainerOnboardingView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F766E),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        child: const Text('Apply as a Freelance Trainer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqs = [
      {
        'q': 'Where do the personal training sessions take place?',
        'a': 'Trainers come directly to your preferred location in your city: your home/apartment, society clubhouse gym, or a nearby public park (such as Cubbon Park in Bengaluru or Carter Road in Mumbai).'
      },
      {
        'q': 'Do I need my own gym equipment?',
        'a': 'No! Freelance trainers on FitPro India bring portable workout equipment including resistance loop bands, agility ladders, kettlebells, yoga blocks, and mobility gear depending on your training style.'
      },
      {
        'q': 'What happens if I need to cancel or reschedule?',
        'a': 'You can reschedule or cancel directly from your customer dashboard. Cancellations made more than 4 hours before the appointment receive a 100% refund.'
      },
      {
        'q': 'How are trainer credentials verified?',
        'a': 'Our compliance team checks official certificates (ACE, ACSM, Yoga Alliance, K11) against issuer databases, verifies Government ID (Aadhaar/PAN), and conducts background checks before any trainer can accept bookings.'
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...faqs.map((faq) => ExpansionTile(
                    title: Text(
                      faq['q']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          faq['a']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textDarkSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                'FitPro India Marketplace • Designed for Bangalore, Mumbai, Delhi NCR, Hyderabad & Pune',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDarkMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2026 FitPro India Technologies Pvt. Ltd. All rights reserved. Prices in INR (₹) inclusive of applicable taxes.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textDarkMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

