import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_model.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../public/landing_page.dart';
import '../public/trainer_search_view.dart';
import '../public/trainer_profile_view.dart';
import '../booking/booking_flow_view.dart';
import '../customer/customer_dashboard_view.dart';
import '../trainer/trainer_dashboard_view.dart';
import '../admin/admin_dashboard_view.dart';
import '../support/support_dashboard_view.dart';
import '../onboarding/welcome_onboarding_view.dart';
import '../onboarding/customer_onboarding_view.dart';
import '../onboarding/trainer_onboarding_view.dart';
import '../auth/trainer_auth_view.dart';
import '../auth/admin_auth_view.dart';
import '../auth/support_auth_view.dart';

enum DeviceMode {
  fullWeb,
  mobile,
  tablet;

  String get label {
    switch (this) {
      case DeviceMode.fullWeb:
        return 'Desktop Web';
      case DeviceMode.mobile:
        return 'Mobile (iPhone / Android)';
      case DeviceMode.tablet:
        return 'Tablet (iPad)';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceMode.fullWeb:
        return Icons.desktop_windows;
      case DeviceMode.mobile:
        return Icons.phone_iphone;
      case DeviceMode.tablet:
        return Icons.tablet_mac;
    }
  }
}

class DevicePreviewShell extends StatefulWidget {
  final Widget child;
  const DevicePreviewShell({super.key, required this.child});

  @override
  State<DevicePreviewShell> createState() => _DevicePreviewShellState();
}

class _DevicePreviewShellState extends State<DevicePreviewShell> {
  DeviceMode _deviceMode = DeviceMode.fullWeb;
  bool _isLandscape = false;

  // Jump to specific flow shortcut
  String _selectedFlow = 'role_default';

  @override
  Widget build(BuildContext context) {
    // If running on actual mobile device in native app, show direct UI
    if (!kIsWeb &&
        defaultTargetPlatform != TargetPlatform.windows &&
        defaultTargetPlatform != TargetPlatform.macOS &&
        defaultTargetPlatform != TargetPlatform.linux) {
      return widget.child;
    }

    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Column(
        children: [
          // Studio Control Toolbar
          _buildSimulatorToolbar(context, state),

          // Main Viewport Area
          Expanded(
            child: _deviceMode == DeviceMode.fullWeb
                ? _buildActiveFlowContent(state)
                : _buildDeviceMockupFrame(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorToolbar(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Logo & Badge
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'HOMEFIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' India',
                      style: TextStyle(color: AppColors.primaryLight),
                    ),
                    TextSpan(
                      text: ' UI/UX Studio',
                      style: TextStyle(
                        color: AppColors.textDarkMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Device Selector Buttons
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: DeviceMode.values.map((mode) {
                    final isSel = _deviceMode == mode;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _deviceMode = mode;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              mode.icon,
                              size: 14,
                              color: isSel
                                  ? Colors.white
                                  : AppColors.textDarkMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              mode.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSel
                                    ? Colors.white
                                    : AppColors.textDarkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),

              // Orientation Toggle
              if (_deviceMode != DeviceMode.fullWeb) ...[
                IconButton(
                  tooltip: _isLandscape
                      ? 'Switch to Portrait'
                      : 'Switch to Landscape',
                  icon: Icon(
                    _isLandscape
                        ? Icons.stay_current_landscape
                        : Icons.stay_current_portrait,
                    size: 18,
                  ),
                  color: AppColors.primaryLight,
                  onPressed: () {
                    setState(() {
                      _isLandscape = !_isLandscape;
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],

              // Flow Shortcut Jump Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFlow,
                    isDense: true,
                    dropdownColor: AppColors.surfaceDark,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryLight,
                      size: 18,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'role_default',
                        child: Text(
                          '⚡ Auto (Role View)',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'welcome_onboarding',
                        child: Text(
                          '✨ Welcome & Onboarding Hub',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'customer_onboarding',
                        child: Text(
                          '🎯 Customer Onboarding & Goals',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'trainer_onboarding',
                        child: Text(
                          '💪 Trainer Application (10-Step)',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'landing',
                        child: Text(
                          '🌐 Public Landing Page',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'search',
                        child: Text(
                          '🔍 Trainer Search & Filters',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'profile',
                        child: Text(
                          '👤 Trainer Profile (Priya)',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'booking',
                        child: Text(
                          '💳 Slot Hold & UPI Checkout',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'customer_dashboard',
                        child: Text(
                          '📊 Customer Dashboard',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'trainer_dashboard',
                        child: Text(
                          '⏱️ Trainer Portal & Timer',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'admin_dashboard',
                        child: Text(
                          '🛡️ Admin Verification Queue',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'support_dashboard',
                        child: Text(
                          '🎧 Support & Dispute Console',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedFlow = val;
                          if (val == 'trainer_dashboard') {
                            state.setRole(UserRole.trainer);
                          } else if (val == 'admin_dashboard') {
                            state.setRole(UserRole.admin);
                          } else if (val == 'support_dashboard') {
                            state.setRole(UserRole.support);
                          } else if (val == 'customer_dashboard') {
                            state.setRole(UserRole.customer);
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Role Switcher Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserRole>(
                    value: state.currentRole,
                    isDense: true,
                    dropdownColor: AppColors.surfaceDark,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: UserRole.customer,
                        child: Text(
                          'Role: Customer',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: UserRole.trainer,
                        child: Text(
                          'Role: Trainer Pro',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: UserRole.admin,
                        child: Text(
                          'Role: Admin Ops',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: UserRole.support,
                        child: Text(
                          'Role: Support Agent',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (role) {
                      if (role != null) {
                        setState(() {
                          _selectedFlow = 'role_default';
                        });
                        state.setRole(role);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Device Frame Canvas for Mobile & Tablet ---
  Widget _buildDeviceMockupFrame(BuildContext context, AppState state) {
    // Phone standard dimensions (iPhone 16 Pro: 393 x 852 px)
    // Tablet dimensions (iPad Air: 820 x 1180 px)
    final double targetWidth = _deviceMode == DeviceMode.mobile
        ? (_isLandscape ? 852.0 : 393.0)
        : (_isLandscape ? 1180.0 : 820.0);

    final double targetHeight = _deviceMode == DeviceMode.mobile
        ? (_isLandscape ? 393.0 : 852.0)
        : (_isLandscape ? 820.0 : 1180.0);

    final double frameRadius = _deviceMode == DeviceMode.mobile ? 48.0 : 32.0;
    final double bezelBorder = _deviceMode == DeviceMode.mobile ? 12.0 : 14.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            // Frame Device Label
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_deviceMode.icon, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 6),
                Text(
                  '${_deviceMode == DeviceMode.mobile ? "Mobile Device View (393 × 852 px)" : "Tablet Device View (820 × 1180 px)"} • Touch & Scroll Enabled',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDarkSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Device Chassis Body
            Container(
              width: targetWidth + (bezelBorder * 2),
              height: targetHeight + (bezelBorder * 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(frameRadius + 10),
                border: Border.all(color: const Color(0xFF475569), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 40,
                    spreadRadius: 8,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              padding: EdgeInsets.all(bezelBorder),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(frameRadius),
                child: Stack(
                  children: [
                    // Simulated Screen Canvas with custom MediaQuery overrides
                    Positioned.fill(
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: Size(targetWidth, targetHeight),
                          padding: EdgeInsets.only(
                            top: _deviceMode == DeviceMode.mobile ? 44.0 : 24.0,
                            bottom: _deviceMode == DeviceMode.mobile
                                ? 34.0
                                : 20.0,
                          ),
                          viewPadding: EdgeInsets.only(
                            top: _deviceMode == DeviceMode.mobile ? 44.0 : 24.0,
                            bottom: _deviceMode == DeviceMode.mobile
                                ? 34.0
                                : 20.0,
                          ),
                        ),
                        child: Container(
                          color: AppColors.backgroundDark,
                          child: _buildActiveFlowContent(
                            state,
                            isEmbeddedInDevice: true,
                          ),
                        ),
                      ),
                    ),

                    // Top Status Bar & Dynamic Island (Mobile only)
                    if (_deviceMode == DeviceMode.mobile && !_isLandscape)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 44,
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '9:41',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Dynamic Island
                              Container(
                                width: 110,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.signal_cellular_4_bar,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.wifi,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.battery_full,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Bottom Home Indicator Bar (Mobile only)
                    if (_deviceMode == DeviceMode.mobile && !_isLandscape)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 135,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Content Dispatcher ---
  Widget _buildActiveFlowContent(
    AppState state, {
    bool isEmbeddedInDevice = false,
  }) {
    if (_selectedFlow == 'welcome_onboarding') {
      return const WelcomeOnboardingView();
    } else if (_selectedFlow == 'customer_onboarding') {
      return const CustomerOnboardingView();
    } else if (_selectedFlow == 'trainer_onboarding') {
      return const TrainerOnboardingView();
    } else if (_selectedFlow == 'landing') {
      return LandingPage(
        onExploreClick: () => setState(() => _selectedFlow = 'search'),
      );
    } else if (_selectedFlow == 'search') {
      return const TrainerSearchView();
    } else if (_selectedFlow == 'profile') {
      final trainer = state.trainers.first;
      return TrainerProfileView(trainer: trainer);
    } else if (_selectedFlow == 'booking') {
      final trainer = state.trainers.first;
      return BookingFlowView(trainer: trainer, service: trainer.services.first);
    } else if (_selectedFlow == 'customer_dashboard') {
      return const CustomerDashboardView();
    } else if (_selectedFlow == 'trainer_dashboard') {
      return state.isTrainerRegistered
          ? const TrainerDashboardView()
          : TrainerAuthView(onAuthenticated: () => setState(() {}));
    } else if (_selectedFlow == 'admin_dashboard') {
      return state.isAdminRegistered
          ? const AdminDashboardView()
          : AdminAuthView(onAuthenticated: () => setState(() {}));
    } else if (_selectedFlow == 'support_dashboard') {
      return state.isSupportRegistered
          ? const SupportDashboardView()
          : SupportAuthView(onAuthenticated: () => setState(() {}));
    }

    // Default flow based on active role
    switch (state.currentRole) {
      case UserRole.customer:
        return widget.child;
      case UserRole.trainer:
        return state.isTrainerRegistered
            ? const TrainerDashboardView()
            : TrainerAuthView(onAuthenticated: () => setState(() {}));
      case UserRole.admin:
        return state.isAdminRegistered
            ? const AdminDashboardView()
            : AdminAuthView(onAuthenticated: () => setState(() {}));
      case UserRole.support:
        return state.isSupportRegistered
            ? const SupportDashboardView()
            : SupportAuthView(onAuthenticated: () => setState(() {}));
    }
  }
}
