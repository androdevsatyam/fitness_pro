import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pro/core/state/app_state.dart';
import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/models/user_model.dart';
import 'package:fitness_pro/core/utils/formatters.dart';
import 'package:fitness_pro/views/public/trainer_search_view.dart';

class CustomerOnboardingView extends StatefulWidget {
  const CustomerOnboardingView({super.key});

  @override
  State<CustomerOnboardingView> createState() => _CustomerOnboardingViewState();
}

class _CustomerOnboardingViewState extends State<CustomerOnboardingView> {
  int _step = 0; // 0 = Phone/OTP, 1 = Goals & Preferences, 2 = Summary & Match

  final TextEditingController _phoneCtrl = TextEditingController(
    text: '9845012345',
  );
  final TextEditingController _otpCtrl = TextEditingController(text: '4589');
  final TextEditingController _nameCtrl = TextEditingController(
    text: 'Aarav Sharma',
  );
  String _selectedCity = 'Gurugram';
  bool _otpSent = false;
  bool _safetyAcknowledged = false;

  // Preferences
  String _primaryGoal = 'Weight Management & Fat Loss';
  String _trainingStyle = 'Functional & HIIT';
  String _experienceLevel = 'Intermediate';
  int _durationMinutes = 60;
  String _timeWindow = 'Morning (6 AM - 9 AM)';
  double _budgetInr = 1500;
  String _language = 'English / Hindi';
  final List<String> _limitations = [];

  final List<String> _goals = [
    'Weight Management & Fat Loss',
    'Lean Muscle Building',
    'Desk Posture & Back Relief',
    'Cardio & Athletic Endurance',
    'Mindfulness & Flexibility',
    'Senior Joint Health & Mobility',
  ];

  final List<String> _styles = [
    'Functional & HIIT',
    'Classical Yoga',
    'Calisthenics & Bodyweight',
    'Strength & Resistance Training',
    'Mobility & Stretching',
  ];

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _saveAndProceed(AppState state) {
    final prefs = CustomerPreferences(
      primaryGoal: _primaryGoal,
      trainingStyle: _trainingStyle,
      experienceLevel: _experienceLevel,
      preferredDurationMinutes: _durationMinutes,
      preferredTimeWindow: _timeWindow,
      budgetPerSession: _budgetInr,
      preferredLanguage: _language,
      exerciseLimitations: _limitations,
    );
    if (!state.isCustomerRegistered)
      state.registerCustomer(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        city: _selectedCity,
      );
    state.updateCustomerPreferences(prefs);
    state.updateSearchFilters(
      city: _selectedCity,
      category: _trainingStyle.contains('Yoga')
          ? 'Yoga & Mindfulness'
          : 'Functional Training',
      maxBudget: _budgetInr,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TrainerSearchView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Journey Setup'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TrainerSearchView()),
              );
            },
            child: const Text(
              'Skip Quiz',
              style: TextStyle(color: AppColors.primaryLight),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Progress Indicator
                    Row(
                      children: [
                        _stepIndicator(0, 'Verification'),
                        const SizedBox(width: 8),
                        _stepIndicator(1, 'Fitness Goals'),
                        const SizedBox(width: 8),
                        _stepIndicator(2, 'Matching Pro'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (_step == 0) _buildPhoneOtpStep(),
                    if (_step == 1) _buildGoalsStep(),
                    if (_step == 2) _buildMatchingStep(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepIndicator(int index, String label) {
    final isActive = _step == index;
    final isDone = _step > index;

    return Expanded(
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : isDone
                  ? AppColors.accent
                  : AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.ink : AppColors.textDarkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Account Verification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enter your Indian phone number to receive a one-time OTP.',
          style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 20),

        const Text(
          'Full Name',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'e.g. Aarav Sharma',
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Phone Number',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            prefixText: '+91  ',
            prefixIcon: Icon(Icons.phone_android),
            hintText: '98450 12345',
          ),
        ),
        const SizedBox(height: 16),

        if (!_otpSent)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _otpSent = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo OTP sent: 4589')),
                );
              },
              child: const Text('Send Verification Code'),
            ),
          )
        else ...[
          const Text(
            'Enter 4-Digit OTP',
            style: TextStyle(fontSize: 12, color: AppColors.accent),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.pin),
              hintText: '4589',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_otpCtrl.text.trim() != '4589' ||
                    !RegExp(
                      r'^[6-9][0-9]{9}$',
                    ).hasMatch(_phoneCtrl.text.trim()) ||
                    _nameCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter your name, a valid mobile number and demo OTP 4589.',
                      ),
                    ),
                  );
                  return;
                }
                setState(() => _step = 1);
              },
              child: const Text('Verify & Continue'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your primary fitness goal?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        ..._goals.map((goal) {
          final isSel = _primaryGoal == goal;
          return RadioListTile<String>(
            value: goal,
            groupValue: _primaryGoal,
            title: Text(
              goal,
              style: TextStyle(
                fontSize: 13,
                color: isSel ? AppColors.ink : AppColors.muted,
              ),
            ),
            dense: true,
            activeColor: AppColors.primaryLight,
            onChanged: (val) {
              if (val != null) setState(() => _primaryGoal = val);
            },
          );
        }),
        const SizedBox(height: 16),

        const Text(
          'Preferred Training Style',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _styles.map((st) {
            final isSel = _trainingStyle == st;
            return ChoiceChip(
              label: Text(st),
              selected: isSel,
              onSelected: (_) => setState(() => _trainingStyle = st),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your City',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            DropdownButton<String>(
              value: _selectedCity,
              dropdownColor: AppColors.surfaceDark,
              items: const [
                DropdownMenuItem(value: 'Gurugram', child: Text('Gurugram')),
                DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai')),
                DropdownMenuItem(value: 'Delhi NCR', child: Text('Delhi NCR')),
                DropdownMenuItem(value: 'Hyderabad', child: Text('Hyderabad')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedCity = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ready for general fitness training'),
          subtitle: const Text(
            'I will share exercise limitations with my trainer and seek medical clearance when needed. Trainers do not diagnose or treat medical conditions.',
          ),
          value: _safetyAcknowledged,
          onChanged: (value) =>
              setState(() => _safetyAcknowledged = value ?? false),
        ),
        Text(
          'Budget per Session: ${Formatters.formatINR(_budgetInr)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        Slider(
          value: _budgetInr,
          min: 800,
          max: 3000,
          divisions: 22,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.borderDark,
          onChanged: (val) => setState(() => _budgetInr = val),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _step = 0),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: _safetyAcknowledged
                  ? () => setState(() => _step = 2)
                  : null,
              child: const Text('Find Matching Trainers'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchingStep(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Icon(
            Icons.check_circle_outline,
            color: AppColors.accent,
            size: 54,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Preferences Saved!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'We matched certified freelance trainers who travel to your area.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              _summaryRow('Primary Goal', _primaryGoal),
              _summaryRow('Workout Style', _trainingStyle),
              _summaryRow('Location', '$_selectedCity (In-Person Doorstep)'),
              _summaryRow('Budget Limit', Formatters.formatINR(_budgetInr)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _saveAndProceed(state),
            child: const Text('View Matched Trainers'),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textDarkMuted,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
