import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';

class AdminAuthView extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const AdminAuthView({super.key, required this.onAuthenticated});

  @override
  State<AdminAuthView> createState() => _AdminAuthViewState();
}

class _AdminAuthViewState extends State<AdminAuthView> {
  final TextEditingController _adminEmailCtrl = TextEditingController(
    text: 'admin.ops@homefit.demo',
  );
  final TextEditingController _adminPassCtrl = TextEditingController(
    text: 'AdminOps@2026',
  );
  bool _obscurePass = true;

  @override
  void dispose() {
    _adminEmailCtrl.dispose();
    _adminPassCtrl.dispose();
    super.dispose();
  }

  void _loginAdmin(AppState state) {
    state.loginAdmin(email: _adminEmailCtrl.text.trim());
    widget.onAuthenticated();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.accent,
        content: Text('Admin authorization granted. Welcome, Vikram Malhotra!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Console Authentication')),
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
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: AppColors.accent,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Platform Admin Access',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Restricted Internal Governance Console',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textDarkSecondary,
                                ),
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
                          Icon(
                            Icons.security,
                            color: AppColors.warning,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Administrative tools, trainer accreditation queues, dispute refunds, and fee configurations are strictly restricted.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Admin Email ID',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _adminEmailCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined, size: 18),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Security Password',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _adminPassCtrl,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, size: 18),
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _loginAdmin(state),
                        icon: const Icon(Icons.verified_user, size: 18),
                        label: const Text(
                          'Authorize & Sign In as Admin (Demo)',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
