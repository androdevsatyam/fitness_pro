import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';

class SupportAuthView extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const SupportAuthView({super.key, required this.onAuthenticated});

  @override
  State<SupportAuthView> createState() => _SupportAuthViewState();
}

class _SupportAuthViewState extends State<SupportAuthView> {
  final TextEditingController _agentEmailCtrl = TextEditingController(text: 'neha.support@fitpro.in');
  final TextEditingController _agentPassCtrl = TextEditingController(text: 'SupportDesk@2026');
  bool _obscurePass = true;

  @override
  void dispose() {
    _agentEmailCtrl.dispose();
    _agentPassCtrl.dispose();
    super.dispose();
  }

  void _loginSupport(AppState state) {
    state.loginSupport(email: _agentEmailCtrl.text.trim());
    widget.onAuthenticated();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.accent,
        content: Text('Support Agent console unlocked. Welcome, Neha Patel!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Desk Authentication'),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.support_agent, color: AppColors.info, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Support Agent Console',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                'Grievance & Dispute Triage Portal',
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

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDarkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: AppColors.info, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Support agents handle assigned client tickets and booking grievances under least-privilege data access.',
                              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text('Agent Email ID', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _agentEmailCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.badge_outlined, size: 18),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Agent Password', style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _agentPassCtrl,
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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _loginSupport(state),
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text('Unlock Console (Demo: Neha Patel)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                          padding: const EdgeInsets.symmetric(vertical: 14),
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

