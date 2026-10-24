import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/customer_trainer_card.dart';

class TrainerSearchView extends StatefulWidget {
  const TrainerSearchView({super.key});
  @override
  State<TrainerSearchView> createState() => _TrainerSearchViewState();
}

class _TrainerSearchViewState extends State<TrainerSearchView> {
  final _search = TextEditingController();
  bool _lowestPrice = false;
  @override
  void initState() {
    super.initState();
    _search.text = context.read<AppState>().searchQuery;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _filters(AppState state) async {
    var budget = state.maxBudget;
    var category = state.selectedCategory;
    var gender = state.selectedGender;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A few preferences',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose what matters to you. Everything else is optional.',
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Type of training',
                  ),
                  items: [
                    for (final c in const [
                      'All',
                      'Functional Training',
                      'Yoga & Mindfulness',
                      'Stretching & Mobility',
                      'Mat Pilates',
                      'Senior Fitness',
                      'Calisthenics & Bodyweight',
                    ])
                      DropdownMenuItem(
                        value: c,
                        child: Text(c == 'All' ? 'Any type of training' : c),
                      ),
                  ],
                  onChanged: (v) => setSheetState(() => category = v!),
                ),
                const SizedBox(height: 24),
                Text(
                  'Budget up to ₹${budget.round()} / session',
                  style: const TextStyle(color: AppColors.ink),
                ),
                Slider(
                  value: budget.clamp(500, 3000),
                  min: 500,
                  max: 3000,
                  divisions: 25,
                  onChanged: (v) => setSheetState(() => budget = v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: gender,
                  decoration: const InputDecoration(
                    labelText: 'Trainer preference',
                  ),
                  items: [
                    for (final g in const ['All', 'Female', 'Male'])
                      DropdownMenuItem(
                        value: g,
                        child: Text(g == 'All' ? 'No preference' : g),
                      ),
                  ],
                  onChanged: (v) => setSheetState(() => gender = v!),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        state.updateSearchFilters(
                          category: 'All',
                          maxBudget: 3000,
                          gender: 'All',
                        );
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Reset'),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        state.updateSearchFilters(
                          category: category,
                          maxBudget: budget,
                          gender: gender,
                        );
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Show trainers'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final trainers = state.filteredTrainers;
    trainers.sort(
      (a, b) => _lowestPrice
          ? (a.services.isEmpty ? 0.0 : a.services.first.priceInr).compareTo(
              b.services.isEmpty ? 0.0 : b.services.first.priceInr,
            )
          : b.rating.compareTo(a.rating),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FIND YOUR PERSON',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Good guidance. At your doorstep.',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 35,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Explore trainers in Gurugram. Compare at your own pace.',
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _search,
                          onChanged: (v) => state.updateSearchFilters(query: v),
                          decoration: const InputDecoration(
                            hintText: 'Name or type of training',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _filters(state),
                        icon: const Icon(Icons.tune, size: 18),
                        label: const Text('Filters'),
                      ),
                    ],
                  ),
                  if (state.selectedCategory != 'All' ||
                      state.maxBudget < 3000 ||
                      state.selectedGender != 'All')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (state.selectedCategory != 'All')
                            InputChip(
                              label: Text(state.selectedCategory),
                              onDeleted: () =>
                                  state.updateSearchFilters(category: 'All'),
                            ),
                          if (state.maxBudget < 3000)
                            InputChip(
                              label: Text('Up to ₹${state.maxBudget.round()}'),
                              onDeleted: () =>
                                  state.updateSearchFilters(maxBudget: 3000),
                            ),
                          if (state.selectedGender != 'All')
                            InputChip(
                              label: Text(state.selectedGender),
                              onDeleted: () =>
                                  state.updateSearchFilters(gender: 'All'),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${trainers.length} ${trainers.length == 1 ? 'trainer' : 'trainers'} to get to know',
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _lowestPrice = !_lowestPrice),
                        icon: const Icon(Icons.swap_vert, size: 17),
                        label: Text(
                          _lowestPrice ? 'Price: low to high' : 'Highest rated',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (trainers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.spa_outlined,
                            size: 36,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'A little more room to search.',
                            style: TextStyle(fontSize: 23),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No trainers match these preferences yet. Try a broader search.',
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {
                              _search.clear();
                              state.updateSearchFilters(
                                query: '',
                                category: 'All',
                                gender: 'All',
                                maxBudget: 3000,
                                city: 'Gurugram',
                              );
                            },
                            child: const Text('Clear preferences'),
                          ),
                        ],
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900
                            ? 3
                            : constraints.maxWidth >= 600
                            ? 2
                            : 1;
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            for (final trainer in trainers)
                              SizedBox(
                                width:
                                    (constraints.maxWidth -
                                        (columns - 1) * 20) /
                                    columns,
                                child: CustomerTrainerCard(trainer: trainer),
                              ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                  const Text(
                    'Session prices are shown on each profile. Review the full total before confirming a booking.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
