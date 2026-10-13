import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/state/app_state.dart';
import 'core/models/user_model.dart';
import 'core/utils/responsive.dart';
import 'views/shared/role_switcher_bar.dart';
import 'views/shared/device_preview_shell.dart';
import 'views/public/landing_page.dart';
import 'views/public/trainer_search_view.dart';
import 'views/customer/customer_dashboard_view.dart';
import 'views/trainer/trainer_dashboard_view.dart';
import 'views/admin/admin_dashboard_view.dart';
import 'views/support/support_dashboard_view.dart';
import 'views/onboarding/welcome_onboarding_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const FitProApp(),
    ),
  );
}

class FitProApp extends StatelessWidget {
  const FitProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPro India - Freelance Fitness Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: const DevicePreviewShell(
        child: MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Navigation index for customer view: 0 = Landing, 1 = Search, 2 = Dashboard, 3 = Onboarding
  int _customerNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: Column(
        children: [
          // Global Role Switcher Banner (allows testing all 4 roles instantly)
          const RoleSwitcherBar(),

          // Main Role-Specific View Body
          Expanded(
            child: _buildRoleView(state.currentRole),
          ),
        ],
      ),
      bottomNavigationBar: (state.currentRole == UserRole.customer && !isDesktop)
          ? NavigationBar(
              selectedIndex: _customerNavIndex,
              onDestinationSelected: (idx) {
                setState(() => _customerNavIndex = idx);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppColors.primaryLight),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  selectedIcon: Icon(Icons.search, color: AppColors.primaryLight),
                  label: 'Trainers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today, color: AppColors.primaryLight),
                  label: 'My Bookings',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome, color: AppColors.primaryLight),
                  label: 'Onboarding',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildRoleView(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return _buildCustomerFlow();
      case UserRole.trainer:
        return const TrainerDashboardView();
      case UserRole.admin:
        return const AdminDashboardView();
      case UserRole.support:
        return const SupportDashboardView();
    }
  }

  Widget _buildCustomerFlow() {
    switch (_customerNavIndex) {
      case 0:
        return LandingPage(
          onExploreClick: () {
            setState(() => _customerNavIndex = 1);
          },
        );
      case 1:
        return const TrainerSearchView();
      case 2:
        return const CustomerDashboardView();
      case 3:
        return const WelcomeOnboardingView();
      default:
        return LandingPage(
          onExploreClick: () {
            setState(() => _customerNavIndex = 1);
          },
        );
    }
  }
}
