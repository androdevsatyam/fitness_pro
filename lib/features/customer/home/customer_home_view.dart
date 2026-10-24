import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/wellness_scene.dart';
import '../widgets/customer_trainer_card.dart';

class LandingPage extends StatelessWidget {
  final VoidCallback onExploreClick;
  const LandingPage({super.key, required this.onExploreClick});

  void _explore(BuildContext context, [String category = 'All']) {
    context.read<AppState>().updateSearchFilters(
      category: category,
      query: '',
      city: 'Gurugram',
    );
    onExploreClick();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;
    final trainers = state.trainers
        .where(
          (t) =>
              t.idVerified &&
              !t.isProfilePaused &&
              t.verificationStatus.name == 'approved',
        )
        .take(3)
        .toList();
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 36 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: wide ? 64 : 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final words = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'AT HOME IN GURUGRAM',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 2,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'A little movement.\nA little more you.',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: wide ? 63 : 43,
                            height: 1.14,
                            letterSpacing: -1.8,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const ConstrainedText(
                          'Personal fitness, in the comfort of home. Find a trainer who understands your goals and moves at your pace.',
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () => _explore(context),
                          label: const Text('Find your trainer'),
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          iconAlignment: IconAlignment.end,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Explore freely. No account needed to get started.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                    if (!wide)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          words,
                          const SizedBox(height: 36),
                          const Center(
                            child: SizedBox(width: 340, child: WellnessScene()),
                          ),
                        ],
                      );
                    return Row(
                      children: [
                        Expanded(flex: 6, child: words),
                        const SizedBox(width: 56),
                        const Expanded(flex: 5, child: WellnessScene()),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Wrap(
                  spacing: 28,
                  runSpacing: 14,
                  children: [
                    _Reassurance(
                      Icons.verified_user_outlined,
                      'Verified professionals',
                    ),
                    _Reassurance(
                      Icons.home_outlined,
                      'No gym or equipment needed',
                    ),
                    _Reassurance(
                      Icons.schedule_outlined,
                      'A time that works for you',
                    ),
                  ],
                ),
                SizedBox(height: wide ? 90 : 64),
                const _Eyebrow('START WITH HOW YOU WANT TO FEEL'),
                const SizedBox(height: 14),
                const _Heading('What would feel good today?'),
                const SizedBox(height: 12),
                const Text('There is no perfect starting point. Just yours.'),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final count = constraints.maxWidth >= 850
                        ? 4
                        : constraints.maxWidth >= 500
                        ? 2
                        : 1;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final option in const [
                          (
                            'Feel stronger',
                            'Everyday strength, built gently.',
                            'Functional Training',
                            Icons.fitness_center_outlined,
                          ),
                          (
                            'Find my calm',
                            'Yoga, breath and a little stillness.',
                            'Yoga & Mindfulness',
                            Icons.self_improvement,
                          ),
                          (
                            'Move more freely',
                            'Stretch, unwind and feel less stiff.',
                            'Stretching & Mobility',
                            Icons.accessibility_new,
                          ),
                          (
                            'Stay active as I age',
                            'Balance and confidence, at your pace.',
                            'Senior Fitness',
                            Icons.directions_walk,
                          ),
                        ])
                          SizedBox(
                            width:
                                (constraints.maxWidth - (count - 1) * 16) /
                                count,
                            child: _GoalCard(
                              title: option.$1,
                              description: option.$2,
                              icon: option.$4,
                              onTap: () => _explore(context, option.$3),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () => _explore(context),
                  child: const Text('Explore all types of training →'),
                ),
                SizedBox(height: wide ? 90 : 64),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(wide ? 36 : 24),
                  decoration: BoxDecoration(
                    color: AppColors.soft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Eyebrow('SIMPLE FROM THE FIRST STEP'),
                      const SizedBox(height: 14),
                      const _Heading('Your routine. Made a little easier.'),
                      const SizedBox(height: 30),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final steps = [
                            const _Step(
                              '01',
                              'Find your person',
                              'Browse experience, training styles and prices. Take your time.',
                            ),
                            const _Step(
                              '02',
                              'Make it fit your day',
                              'Choose a session and a time. Tell us where you would like to train.',
                            ),
                            const _Step(
                              '03',
                              'Feel at home',
                              'Your trainer comes to you. Start small and build a routine together.',
                            ),
                          ];
                          return constraints.maxWidth >= 700
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final step in steps)
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 24,
                                          ),
                                          child: step,
                                        ),
                                      ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    for (final step in steps)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 28,
                                        ),
                                        child: step,
                                      ),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: wide ? 90 : 64),
                const _Eyebrow('A HUMAN CONNECTION'),
                const SizedBox(height: 14),
                const _Heading('Good guidance starts with good people.'),
                const SizedBox(height: 12),
                const Text('Get to know your trainer before you book.'),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final count = constraints.maxWidth >= 900
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
                                (constraints.maxWidth - (count - 1) * 20) /
                                count,
                            child: CustomerTrainerCard(trainer: trainer),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => _explore(context),
                  child: const Text('Meet all trainers →'),
                ),
                SizedBox(height: wide ? 90 : 64),
                const _Heading('A few things you might be wondering.'),
                const SizedBox(height: 24),
                for (final question in const [
                  (
                    'Do I need equipment?',
                    'No. Start with a little clear floor space, water and comfortable clothes. Your trainer will explain anything else needed for your chosen session.',
                  ),
                  (
                    'I am new to fitness. Is this for me?',
                    'Yes. Tell your trainer where you are starting and what feels comfortable. Sessions can be adapted to your experience.',
                  ),
                  (
                    'Can I look around before signing up?',
                    'Of course. Explore trainers, their experience and session prices. You only need to sign in when you are ready to book.',
                  ),
                ])
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(
                      bottom: 24,
                      right: 24,
                    ),
                    title: Text(
                      question.$1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.ink,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(question.$2),
                      ),
                    ],
                  ),
                const SizedBox(height: 48),
                const Divider(),
                const Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                      'HOMEFIT',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text('Your space. Your pace.   ·   Gurugram'),
                  ],
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConstrainedText extends StatelessWidget {
  final String text;
  const ConstrainedText(this.text, {super.key});
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 440),
    child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
  );
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Georgia',
      fontSize: 31,
      height: 1.25,
      color: AppColors.ink,
      letterSpacing: -0.5,
    ),
  );
}

class _Eyebrow extends StatelessWidget {
  final String text;
  const _Eyebrow(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      letterSpacing: 2,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
  );
}

class _Reassurance extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Reassurance(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 17, color: AppColors.primary),
      const SizedBox(width: 8),
      Flexible(child: Text(text, style: const TextStyle(fontSize: 12))),
    ],
  );
}

class _GoalCard extends StatelessWidget {
  final String title, description;
  final IconData icon;
  final VoidCallback onTap;
  const _GoalCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 25),
            const SizedBox(height: 26),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 9),
            Text(description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 20),
            const Icon(Icons.arrow_forward, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    ),
  );
}

class _Step extends StatelessWidget {
  final String number, title, description;
  const _Step(this.number, this.title, this.description);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        number,
        style: const TextStyle(color: AppColors.primary, fontSize: 13),
      ),
      const SizedBox(height: 16),
      Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      Text(description),
    ],
  );
}
