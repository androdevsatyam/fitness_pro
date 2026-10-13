import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/trainer_model.dart';
import '../../core/models/user_model.dart';
import '../../core/utils/formatters.dart';

class TrainerOnboardingView extends StatefulWidget {
  const TrainerOnboardingView({super.key});

  @override
  State<TrainerOnboardingView> createState() => _TrainerOnboardingViewState();
}

class _TrainerOnboardingViewState extends State<TrainerOnboardingView> {
  int _currentStep = 0;

  // Step 1: Personal
  final TextEditingController _nameCtrl = TextEditingController(text: 'Siddharth Rao');
  final TextEditingController _phoneCtrl = TextEditingController(text: '9880198801');
  final TextEditingController _headlineCtrl = TextEditingController(text: 'ACSM Certified Strength & Kettlebell Specialist');
  final TextEditingController _bioCtrl = TextEditingController(
    text: 'Dedicated strength coach with 5 years experience helping busy executives build durable functional strength and core endurance at home.',
  );
  int _experienceYears = 5;
  String _selectedCity = 'Bengaluru';
  double _travelRadiusKm = 10.0;
  final List<String> _languages = ['English', 'Hindi', 'Kannada'];

  // Step 2: Qualifications
  final TextEditingController _certNameCtrl = TextEditingController(text: 'Certified Personal Trainer');
  final TextEditingController _issuingOrgCtrl = TextEditingController(text: 'American College of Sports Medicine (ACSM)');
  final TextEditingController _certNumberCtrl = TextEditingController(text: 'ACSM-IN-2023-882');
  final TextEditingController _issueDateCtrl = TextEditingController(text: '2023-01-15');
  final TextEditingController _expiryDateCtrl = TextEditingController(text: '2027-01-15');

  // Step 3: Identity Verification
  final TextEditingController _aadhaarCtrl = TextEditingController(text: 'XXXX-XXXX-4819');
  bool _aadhaarConsent = true;

  // Step 4: Service & Pricing
  final TextEditingController _srvTitleCtrl = TextEditingController(text: '1-on-1 Kettlebell & Functional Strength');
  final TextEditingController _srvPriceCtrl = TextEditingController(text: '1300');
  int _srvDuration = 60;
  double _travelSurcharge = 100.0;

  // Step 5: Availability & Terms
  bool _termsAccepted = true;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _headlineCtrl.dispose();
    _bioCtrl.dispose();
    _certNameCtrl.dispose();
    _issuingOrgCtrl.dispose();
    _certNumberCtrl.dispose();
    _issueDateCtrl.dispose();
    _expiryDateCtrl.dispose();
    _aadhaarCtrl.dispose();
    _srvTitleCtrl.dispose();
    _srvPriceCtrl.dispose();
    super.dispose();
  }

  void _submitApplication(AppState state) {
    final newTrainer = TrainerModel(
      id: 'trainer_app_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      headline: _headlineCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
      rating: 0.0,
      reviewCount: 0,
      experienceYears: _experienceYears,
      languages: _languages,
      city: _selectedCity,
      serviceAreas: ['Indiranagar', 'Koramangala', 'HSR Layout'],
      maxTravelRadiusKm: _travelRadiusKm,
      preferredTrainingLocations: ['Customer Home', 'Apartment Society Gym', 'Public Park'],
      verificationStatus: VerificationStatus.underReview,
      idVerified: true,
      nextAvailableSlot: 'Pending Admin Verification',
      totalEarningsInr: 0,
      completedSessionsCount: 0,
      qualifications: [
        Qualification(
          id: 'q_new_1',
          certName: _certNameCtrl.text.trim(),
          issuingOrg: _issuingOrgCtrl.text.trim(),
          certNumber: _certNumberCtrl.text.trim(),
          issueDate: _issueDateCtrl.text.trim(),
          expiryDate: _expiryDateCtrl.text.trim(),
          documentUrl: 'https://fitpro.in/docs/cert_${_certNumberCtrl.text}.pdf',
          isVerified: false,
        ),
      ],
      services: [
        ServiceOffering(
          id: 'srv_new_1',
          title: _srvTitleCtrl.text.trim(),
          description: 'Doorstep 1-on-1 personalized session customized to individual goals.',
          category: 'Functional Training',
          durationMinutes: _srvDuration,
          priceInr: double.tryParse(_srvPriceCtrl.text.trim()) ?? 1300.0,
          travelSurchargeInr: _travelSurcharge,
        ),
      ],
    );

    state.submitTrainerApplication(newTrainer);
    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Application & Verification'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _isSubmitted
                    ? _buildSuccessSubmittedView(context, state)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stepper Progress
                          Row(
                            children: [
                              _stepIndicator(0, '1. Profile'),
                              const SizedBox(width: 6),
                              _stepIndicator(1, '2. Credentials'),
                              const SizedBox(width: 6),
                              _stepIndicator(2, '3. Aadhaar ID'),
                              const SizedBox(width: 6),
                              _stepIndicator(3, '4. Pricing'),
                              const SizedBox(width: 6),
                              _stepIndicator(4, '5. Review'),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (_currentStep == 0) _buildStep0Profile(),
                          if (_currentStep == 1) _buildStep1Qualifications(),
                          if (_currentStep == 2) _buildStep2Identity(),
                          if (_currentStep == 3) _buildStep3Services(),
                          if (_currentStep == 4) _buildStep4Review(state),
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
    final isActive = _currentStep == index;
    final isDone = _currentStep > index;

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
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : AppColors.textDarkMuted,
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 0: Profile & Travel Radius ---
  Widget _buildStep0Profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal & Professional Details',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'Independent freelance trainers set their own schedules and travel boundaries.',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 16),

        const Text('Full Name', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.person))),
        const SizedBox(height: 14),

        const Text('Professional Headline', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _headlineCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.badge))),
        const SizedBox(height: 14),

        const Text('Biography & Experience Summary', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _bioCtrl, maxLines: 3, decoration: const InputDecoration(prefixIcon: Icon(Icons.description))),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Base City', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    dropdownColor: AppColors.surfaceDark,
                    items: const [
                      DropdownMenuItem(value: 'Bengaluru', child: Text('Bengaluru')),
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
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Experience: $_experienceYears Years', style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  Slider(
                    value: _experienceYears.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _experienceYears = val.toInt()),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          'Maximum Doorstep Travel Radius: ${_travelRadiusKm.toInt()} km',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(
          value: _travelRadiusKm,
          min: 3,
          max: 20,
          divisions: 17,
          activeColor: AppColors.accent,
          onChanged: (val) => setState(() => _travelRadiusKm = val),
        ),
        const SizedBox(height: 20),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentStep = 1),
            child: const Text('Next: Certifications'),
          ),
        ),
      ],
    );
  }

  // --- Step 1: Qualifications ---
  Widget _buildStep1Qualifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Submit Qualifications & Certifications',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'Every certification is verified against official accreditation registers (ACE, ACSM, Yoga Alliance, K11).',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 16),

        const Text('Certification Name', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _certNameCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.school))),
        const SizedBox(height: 14),

        const Text('Issuing Body / Academy', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _issuingOrgCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.business))),
        const SizedBox(height: 14),

        const Text('Certificate Registration / License Number', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _certNumberCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.pin))),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Issue Date', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  TextField(controller: _issueDateCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expiry Date', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  TextField(controller: _expiryDateCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.event))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Document upload container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.file_present, color: AppColors.accent, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Certificate_Proof_ACSM.pdf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    Text('Uploaded (2.4 MB) • 256-Bit Encrypted Storage', style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document re-uploaded successfully.')),
                  );
                },
                child: const Text('Replace'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(onPressed: () => setState(() => _currentStep = 0), child: const Text('Back')),
            ElevatedButton(onPressed: () => setState(() => _currentStep = 2), child: const Text('Next: Identity Check')),
          ],
        ),
      ],
    );
  }

  // --- Step 2: Identity Verification ---
  Widget _buildStep2Identity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identity & Background Verification',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'In compliance with Indian safety standards, we verify Government ID (Aadhaar / PAN) prior to listing.',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 16),

        const Text('Government ID / Aadhaar Number (Masked)', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _aadhaarCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.credit_card))),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Your private identification is stored in encrypted vault storage and is never exposed to customers or unprivileged agents.',
                  style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        CheckboxListTile(
          value: _aadhaarConsent,
          onChanged: (val) => setState(() => _aadhaarConsent = val ?? true),
          title: const Text(
            'I consent to identity verification and platform safety background screening.',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(onPressed: () => setState(() => _currentStep = 1), child: const Text('Back')),
            ElevatedButton(onPressed: () => setState(() => _currentStep = 3), child: const Text('Next: Services & Rates')),
          ],
        ),
      ],
    );
  }

  // --- Step 3: Define Services & Rates ---
  Widget _buildStep3Services() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Your Services & Session Rates',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 6),
        const Text(
          'You are completely free to set your own hourly rate in INR (₹). You keep 85-90% of every session fee.',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 16),

        const Text('Primary Service Title', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
        const SizedBox(height: 6),
        TextField(controller: _srvTitleCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.fitness_center))),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price per Session (₹)', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  TextField(controller: _srvPriceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixIcon: Icon(Icons.currency_rupee))),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Duration', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    value: _srvDuration,
                    dropdownColor: AppColors.surfaceDark,
                    items: const [
                      DropdownMenuItem(value: 45, child: Text('45 Minutes')),
                      DropdownMenuItem(value: 60, child: Text('60 Minutes')),
                      DropdownMenuItem(value: 90, child: Text('90 Minutes')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _srvDuration = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          'Doorstep Travel Surcharge: ${Formatters.formatINR(_travelSurcharge)}',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(
          value: _travelSurcharge,
          min: 0,
          max: 300,
          divisions: 6,
          activeColor: AppColors.primary,
          onChanged: (val) => setState(() => _travelSurcharge = val),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(onPressed: () => setState(() => _currentStep = 2), child: const Text('Back')),
            ElevatedButton(onPressed: () => setState(() => _currentStep = 4), child: const Text('Next: Final Review')),
          ],
        ),
      ],
    );
  }

  // --- Step 4: Final Review & Submission ---
  Widget _buildStep4Review(AppState state) {
    final price = double.tryParse(_srvPriceCtrl.text.trim()) ?? 1300.0;
    final commissionPercent = state.platformSettings.platformCommissionPercent;
    final trainerEarnings = price * ((100 - commissionPercent) / 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review & Submit for Admin Verification',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              _summaryItem('Applicant Name', _nameCtrl.text),
              _summaryItem('Headline', _headlineCtrl.text),
              _summaryItem('City & Radius', '$_selectedCity (Up to ${_travelRadiusKm.toInt()} km)'),
              _summaryItem('Certification', '${_certNameCtrl.text} (${_issuingOrgCtrl.text})'),
              _summaryItem('Service Price', '${Formatters.formatINR(price)} / session'),
              const Divider(height: 20),
              _summaryItem('Your Net Payout (est.)', '${Formatters.formatINR(trainerEarnings)} per session (Keep ${(100 - commissionPercent).toInt()}%)', isAccent: true),
            ],
          ),
        ),
        const SizedBox(height: 14),

        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (val) => setState(() => _termsAccepted = val ?? true),
          title: const Text(
            'I agree to FitPro India Independent Trainer Marketplace Terms, safety protocols, and weekly automated settlement schedule.',
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(onPressed: () => setState(() => _currentStep = 3), child: const Text('Back')),
            ElevatedButton.icon(
              onPressed: _termsAccepted ? () => _submitApplication(state) : null,
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Submit Application'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String value, {bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isAccent ? FontWeight.bold : FontWeight.w600,
                color: isAccent ? AppColors.accent : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSubmittedView(BuildContext context, AppState state) {
    return Column(
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 64, color: AppColors.accent),
        const SizedBox(height: 16),
        const Text(
          'Application Submitted for Review!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          'Our compliance and safety operations team reviews trainer certificates and ID credentials within 24 hours.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryLight, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '💡 Interactive Prototype Tip: Switch to the "Admin (Vikram)" role at the top right to inspect and approve this application in the verification queue!',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            // Switch role to Admin to let user inspect right away, or return home
            state.setRole(UserRole.admin);
            Navigator.pop(context);
          },
          child: const Text('Go to Admin Verification Queue'),
        ),
      ],
    );
  }
}

