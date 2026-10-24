import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import 'package:fitness_pro/features/customer/auth/customer_auth_dialog.dart';
import 'package:fitness_pro/features/customer/profile/customer_onboarding_view.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A LITTLE ABOUT YOU',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  state.isCustomerRegistered
                      ? 'Hello, ${state.currentUser.name.split(' ').first}.'
                      : 'Make this space yours.',
                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 38),
                ),
                const SizedBox(height: 16),
                Text(
                  state.isCustomerRegistered
                      ? 'Your preferences help your trainer make every session feel right for you.'
                      : 'Keep your bookings and preferences together. You can still explore without an account.',
                ),
                const SizedBox(height: 32),
                if (!state.isCustomerRegistered)
                  ElevatedButton(
                    onPressed: () =>
                        CustomerAuthDialog.show(context, onSuccess: () {}),
                    child: const Text('Log in or create an account'),
                  )
                else ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(state.currentUser.name),
                    subtitle: Text('+91 ${state.currentUser.phone}'),
                  ),
                  const Divider(),
                  const Text(
                    'Your fitness preferences',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.currentUser.preferences?.primaryGoal ??
                        'Choose a goal',
                    style: const TextStyle(color: AppColors.ink),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.currentUser.preferences?.experienceLevel ?? 'Beginner'} · ${state.currentUser.preferences?.preferredDurationMinutes ?? 60}-minute sessions',
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerOnboardingView(),
                      ),
                    ),
                    child: const Text('Update my goals'),
                  ),
                  const SizedBox(height: 48),
                  TextButton.icon(
                    onPressed: state.logoutCustomer,
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Log out'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
