import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';

class CustomerAuthDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  final String? initialTrainerName;

  const CustomerAuthDialog({
    super.key,
    required this.onSuccess,
    this.initialTrainerName,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onSuccess, String? trainerName}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomerAuthDialog(
        onSuccess: onSuccess,
        initialTrainerName: trainerName,
      ),
    );
  }

  @override
  State<CustomerAuthDialog> createState() => _CustomerAuthDialogState();
}

class _CustomerAuthDialogState extends State<CustomerAuthDialog> {
  final TextEditingController _nameCtrl = TextEditingController(text: 'Aarav Sharma');
  final TextEditingController _phoneCtrl = TextEditingController(text: '9845012345');
  final TextEditingController _otpCtrl = TextEditingController(text: '4589');
  String _city = 'Bengaluru';
  bool _otpSent = false;
  bool _isSignUp = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _verifyAndProceed(AppState state) {
    if (_nameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and phone number.')),
      );
      return;
    }

    state.registerCustomer(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      city: _city,
    );

    Navigator.pop(context);
    widget.onSuccess();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accent,
        content: Text('Welcome, ${_nameCtrl.text.trim()}! Resuming your booking reservation.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with security badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.lock_outline, color: AppColors.primaryLight, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSignUp ? 'Quick Registration Required' : 'Sign In to Account',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          widget.initialTrainerName != null
                              ? 'Required to reserve session with ${widget.initialTrainerName}'
                              : 'Registration required to hold & book a session',
                          style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Value banner
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDarkCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: AppColors.accent, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '🔒 You can browse trainers for free. Registration verifies your doorstep address and holds your slot.',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Inputs
              if (_isSignUp) ...[
                const Text('Full Name', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                const SizedBox(height: 4),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, size: 18),
                    hintText: 'e.g. Aarav Sharma',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const Text('Indian Mobile Number (+91)', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
              const SizedBox(height: 4),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: '+91  ',
                  prefixIcon: const Icon(Icons.phone_android, size: 18),
                  hintText: '98450 12345',
                  isDense: true,
                  suffixIcon: !_otpSent
                      ? TextButton(
                          onPressed: () {
                            setState(() => _otpSent = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Demo OTP sent: 4589')),
                            );
                          },
                          child: const Text('Get OTP', style: TextStyle(fontSize: 12, color: AppColors.primaryLight)),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),

              if (_otpSent) ...[
                const Text('Enter 4-Digit OTP Code', style: TextStyle(fontSize: 12, color: AppColors.accent)),
                const SizedBox(height: 4),
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.pin, size: 18),
                    hintText: '4589',
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              if (_isSignUp) ...[
                const Text('City / Training Locality', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _city,
                  dropdownColor: AppColors.surfaceDark,
                  isDense: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Bengaluru', child: Text('Bengaluru, KA')),
                    DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai, MH')),
                    DropdownMenuItem(value: 'Delhi NCR', child: Text('Delhi NCR')),
                    DropdownMenuItem(value: 'Hyderabad', child: Text('Hyderabad, TS')),
                    DropdownMenuItem(value: 'Pune', child: Text('Pune, MH')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _city = val);
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Submit & Quick Demo Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _verifyAndProceed(state),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _isSignUp ? 'Complete Registration & Proceed' : 'Verify & Continue',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                      _otpSent = false;
                    });
                  },
                  child: Text(
                    _isSignUp ? 'Already have an account? Sign In' : 'New user? Create an Account',
                    style: const TextStyle(fontSize: 12, color: AppColors.primaryLight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

