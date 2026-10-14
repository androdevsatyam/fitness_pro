import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../onboarding/trainer_onboarding_view.dart';

class TrainerAuthView extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const TrainerAuthView({super.key, required this.onAuthenticated});

  @override
  State<TrainerAuthView> createState() => _TrainerAuthViewState();
}

class _TrainerAuthViewState extends State<TrainerAuthView> {
  final TextEditingController _emailPhoneCtrl = TextEditingController(text: 'priya.fitness@example.com');
  final TextEditingController _passCtrl = TextEditingController(text: 'Trainer@1234');
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailPhoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login(AppState state) {
    state.loginTrainer(emailOrPhone: _emailPhoneCtrl.text.trim());
    widget.onAuthenticated();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.accent,
        content: Text('Trainer authentication successful. Welcome back, Coach Priya!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Portal Access'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon & Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.sports_kabaddi, color: AppColors.primaryLight, size: 26),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Freelance Trainer Portal',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                'Authentication Required to Conduct Sessions',
                                style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Access policy notice
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: AppColors.accent, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Only registered & compliance-verified trainers can view customer locations, accept requests, and initiate workout sessions.',
                              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text('Registered Email or Phone', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _emailPhoneCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline, size: 18),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Password', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, size: 18),
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, size: 18),
                          onPressed: () => setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _login(state),
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text('Sign In as Coach (Demo: Priya Nair)'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Apply Button
                    const Text('New to FitPro India?', style: TextStyle(fontSize: 12, color: AppColors.textDarkMuted)),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TrainerOnboardingView()),
                          );
                        },
                        icon: const Icon(Icons.app_registration, size: 18, color: AppColors.accent),
                        label: const Text('Apply as Freelance Trainer (10-Step Form)'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.accent),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
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
}

