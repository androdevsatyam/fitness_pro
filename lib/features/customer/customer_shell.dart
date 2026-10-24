import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import 'package:fitness_pro/features/customer/auth/customer_auth_dialog.dart';
import 'package:fitness_pro/features/customer/bookings/customer_bookings_view.dart';
import 'home/customer_home_view.dart';
import 'discovery/trainer_discovery_view.dart';
import 'profile/customer_profile_view.dart';

/// Public navigation only. Role-specific tooling has no public entry point.
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _selected = 0;
  void _navigate(int index) => setState(() => _selected = index);
  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(desktop ? 88 : 68),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: SizedBox(
                height: desktop ? 88 : 68,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'HOMEFIT home',
                        child: InkWell(
                          onTap: () => _navigate(0),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'HOMEFIT',
                              style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (desktop) ...[
                        for (final item in [
                          'Home',
                          'Find a trainer',
                          'My bookings',
                        ].asMap().entries)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TextButton(
                              onPressed: () => _navigate(item.key),
                              child: Text(
                                item.value,
                                style: TextStyle(
                                  color: _selected == item.key
                                      ? AppColors.primary
                                      : AppColors.muted,
                                  fontWeight: _selected == item.key
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 20),
                      ],
                      TextButton(
                        onPressed: () => state.isCustomerRegistered
                            ? _navigate(3)
                            : CustomerAuthDialog.show(
                                context,
                                onSuccess: () {},
                              ),
                        child: Text(
                          state.isCustomerRegistered ? 'My profile' : 'Log in',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: switch (_selected) {
        0 => LandingPage(onExploreClick: () => _navigate(1)),
        1 => const TrainerSearchView(),
        2 =>
          state.isCustomerRegistered
              ? const CustomerBookingsView()
              : _GuestBookings(onExplore: () => _navigate(1)),
        _ => const CustomerProfileView(),
      },
      bottomNavigationBar: desktop
          ? null
          : NavigationBar(
              selectedIndex: _selected,
              onDestinationSelected: _navigate,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: 'Trainers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'Bookings',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: 'You',
                ),
              ],
            ),
    );
  }
}

class _GuestBookings extends StatelessWidget {
  final VoidCallback onExplore;
  const _GuestBookings({required this.onExplore});
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 40,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Your next good habit starts here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Georgia', fontSize: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'Log in to see your sessions. Still looking for your trainer? Take your time exploring.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () =>
                  CustomerAuthDialog.show(context, onSuccess: () {}),
              child: const Text('Log in to see bookings'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onExplore,
              child: const Text('Explore trainers'),
            ),
          ],
        ),
      ),
    ),
  );
}
