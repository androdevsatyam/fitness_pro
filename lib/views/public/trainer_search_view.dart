import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import 'trainer_profile_view.dart';
import '../booking/booking_flow_view.dart';
import '../auth/customer_auth_dialog.dart';

class TrainerSearchView extends StatefulWidget {
  const TrainerSearchView({super.key});

  @override
  State<TrainerSearchView> createState() => _TrainerSearchViewState();
}

class _TrainerSearchViewState extends State<TrainerSearchView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _sortBy = 'rating'; // rating, price_asc, experience

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _searchCtrl.text = state.searchQuery;
  }

  void _bookTrainer(TrainerModel trainer) {
    if (trainer.services.isEmpty) return;
    final state = context.read<AppState>();
    if (!state.isCustomerRegistered) {
      CustomerAuthDialog.show(
        context,
        trainerName: trainer.name,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingFlowView(
                trainer: trainer,
                service: trainer.services.first,
              ),
            ),
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingFlowView(
            trainer: trainer,
            service: trainer.services.first,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    var trainers = state.filteredTrainers;

    // Apply client-side sorting
    if (_sortBy == 'rating') {
      trainers.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'price_asc') {
      trainers.sort((a, b) {
        final priceA = a.services.isEmpty ? 0 : a.services.first.priceInr;
        final priceB = b.services.isEmpty ? 0 : b.services.first.priceInr;
        return priceA.compareTo(priceB);
      });
    } else if (_sortBy == 'experience') {
      trainers.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
    }

    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Personal Trainers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter options',
            onPressed: () => _openFilterModal(context, state),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Search & Filter header bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceDark,
                  border: Border(bottom: BorderSide(color: AppColors.borderDark)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search by specialty, name, or area...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    state.updateSearchFilters(query: '');
                                  },
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onChanged: (val) {
                          state.updateSearchFilters(query: val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Quick city chip / selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.selectedCity,
                          isDense: true,
                          dropdownColor: AppColors.surfaceDark,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Cities')),
                            DropdownMenuItem(value: 'Bengaluru', child: Text('Bengaluru')),
                            DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai')),
                            DropdownMenuItem(value: 'Delhi NCR', child: Text('Delhi NCR')),
                            DropdownMenuItem(value: 'Hyderabad', child: Text('Hyderabad')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              state.updateSearchFilters(city: val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => _openFilterModal(context, state),
                      icon: const Icon(Icons.tune, size: 16),
                      label: Text(
                        isDesktop ? 'More Filters' : 'Filters',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              // Active filter tags and sort bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.backgroundDark,
                child: Row(
                  children: [
                    Text(
                      '${trainers.length} verified trainers available',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textDarkSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Sort by: ',
                      style: TextStyle(fontSize: 12, color: AppColors.textDarkMuted),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isDense: true,
                        dropdownColor: AppColors.surfaceDark,
                        items: const [
                          DropdownMenuItem(value: 'rating', child: Text('Highest Rated')),
                          DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
                          DropdownMenuItem(value: 'experience', child: Text('Most Experienced')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _sortBy = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Results List
              Expanded(
                child: trainers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: AppColors.textDarkMuted),
                            const SizedBox(height: 16),
                            const Text(
                              'No trainers matched your current filters',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try widening your budget, selecting "All Cities", or changing workout styles.',
                              style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _searchCtrl.clear();
                                state.updateSearchFilters(
                                  query: '',
                                  city: 'All',
                                  category: 'All',
                                  maxBudget: 3500,
                                  gender: 'All',
                                );
                              },
                              child: const Text('Reset All Filters'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: trainers.length,
                        itemBuilder: (context, idx) {
                          final trainer = trainers[idx];
                          return _buildDetailedTrainerCard(context, trainer);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedTrainerCard(BuildContext context, TrainerModel trainer) {
    final startingService = trainer.services.isNotEmpty ? trainer.services.first : null;
    final startingPrice = startingService?.priceInr ?? 1000.0;
    final isDesktop = Responsive.isDesktop(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrainerAvatar(trainer, 110, 110),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _buildTrainerInfo(trainer),
                  ),
                  const SizedBox(width: 24),
                  _buildPriceAndCta(context, trainer, startingPrice),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTrainerAvatar(trainer, 80, 80),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  trainer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, color: AppColors.accent, size: 16),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trainer.headline,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.accentGold, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${trainer.rating} (${trainer.reviewCount} verified reviews)',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBadgesRow(trainer),
                  const SizedBox(height: 12),
                  const Divider(),
                  _buildPriceAndCtaMobile(context, trainer, startingPrice),
                ],
              ),
      ),
    );
  }

  Widget _buildTrainerAvatar(TrainerModel trainer, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        trainer.photoUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppColors.surfaceDarkCard,
          child: const Icon(Icons.fitness_center, color: AppColors.primaryLight),
        ),
      ),
    );
  }

  Widget _buildTrainerInfo(TrainerModel trainer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              trainer.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.verified, color: AppColors.accent, size: 18),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'ID & Cert Verified',
                style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.accentGold, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${trainer.rating} (${trainer.reviewCount} reviews)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          trainer.headline,
          style: const TextStyle(fontSize: 13, color: AppColors.primaryLight),
        ),
        const SizedBox(height: 8),
        Text(
          trainer.bio,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: AppColors.textDarkSecondary, height: 1.4),
        ),
        const SizedBox(height: 10),
        _buildBadgesRow(trainer),
      ],
    );
  }

  Widget _buildBadgesRow(TrainerModel trainer) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _pill(Icons.location_on, '${trainer.city} (${trainer.serviceAreas.take(2).join(', ')})'),
        _pill(Icons.directions_car, 'Travels up to ${trainer.maxTravelRadiusKm.toInt()} km'),
        _pill(Icons.translate, trainer.languages.join(', ')),
        _pill(Icons.schedule, 'Next: ${trainer.nextAvailableSlot}', color: AppColors.accent),
      ],
    );
  }

  Widget _pill(IconData icon, String label, {Color color = AppColors.textDarkSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPriceAndCta(BuildContext context, TrainerModel trainer, double price) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Session Fee', style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted)),
          Text(
            Formatters.formatINR(price),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text('at your doorstep', style: TextStyle(fontSize: 11, color: AppColors.accent)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _bookTrainer(trainer),
              child: const Text('Book Session'),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainerProfileView(trainer: trainer),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('View Profile', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndCtaMobile(BuildContext context, TrainerModel trainer, double price) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('From', style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted)),
            Text(
              Formatters.formatINR(price),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TrainerProfileView(trainer: trainer)),
            );
          },
          child: const Text('Profile'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _bookTrainer(trainer),
          child: const Text('Book Now'),
        ),
      ],
    );
  }

  void _openFilterModal(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Trainers',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Max Budget Slider
                Text(
                  'Max Budget: ${Formatters.formatINR(state.maxBudget)} per session',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Slider(
                  value: state.maxBudget,
                  min: 800,
                  max: 3500,
                  divisions: 27,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.borderDark,
                  onChanged: (val) {
                    setModalState(() {});
                    state.updateSearchFilters(maxBudget: val);
                  },
                ),
                const SizedBox(height: 12),

                // Workout Category
                const Text(
                  'Workout Category',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'All',
                    'Functional Training',
                    'Yoga & Mindfulness',
                    'Calisthenics & Bodyweight',
                    'Women\'s Fitness',
                    'Mobility & Rehab',
                  ].map((cat) {
                    final isSel = state.selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      onSelected: (_) {
                        setModalState(() {});
                        state.updateSearchFilters(category: cat);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Gender preference
                const Text(
                  'Trainer Gender Preference',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['All', 'Female', 'Male'].map((g) {
                    final isSel = state.selectedGender == g;
                    return ChoiceChip(
                      label: Text(g),
                      selected: isSel,
                      onSelected: (_) {
                        setModalState(() {});
                        state.updateSearchFilters(gender: g);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

