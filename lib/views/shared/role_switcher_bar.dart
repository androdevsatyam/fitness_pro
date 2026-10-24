import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_model.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';

class RoleSwitcherBar extends StatelessWidget {
  const RoleSwitcherBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF334155), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth > 0
                      ? constraints.maxWidth - 32
                      : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Logo & Market Indicator
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'HOMEFIT',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: ' DEMO',
                                style: TextStyle(color: AppColors.primaryLight),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Gurugram | INR',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Interactive Role Switcher Selector
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isCompact) ...[
                          const Text(
                            'Preview role:',
                            style: TextStyle(
                              color: AppColors.textDarkSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDarkCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<UserRole>(
                              value: state.currentRole,
                              isDense: true,
                              dropdownColor: AppColors.surfaceDark,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.primaryLight,
                                size: 18,
                              ),
                              items: [
                                _roleItem(
                                  UserRole.customer,
                                  Icons.person_outline,
                                  state.isCustomerRegistered
                                      ? 'Customer (Registered)'
                                      : 'Customer (Guest Mode)',
                                ),
                                _roleItem(
                                  UserRole.trainer,
                                  Icons.sports_gymnastics,
                                  state.isTrainerRegistered
                                      ? 'Trainer Pro (Logged In)'
                                      : 'Trainer Pro (Demo login)',
                                ),
                                _roleItem(
                                  UserRole.admin,
                                  Icons.admin_panel_settings,
                                  state.isAdminRegistered
                                      ? 'Admin Ops (Logged In)'
                                      : 'Admin Ops (Demo login)',
                                ),
                                _roleItem(
                                  UserRole.support,
                                  Icons.support_agent,
                                  state.isSupportRegistered
                                      ? 'Support Agent (Logged In)'
                                      : 'Support Agent (Demo login)',
                                ),
                              ],
                              onChanged: (role) {
                                if (role != null) {
                                  state.setRole(role);
                                }
                              },
                            ),
                          ),
                        ),
                        if (!isCompact) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getAuthColor(
                                state,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _getAuthColor(
                                  state,
                                ).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getAuthIcon(state),
                                  size: 12,
                                  color: _getAuthColor(state),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getAuthStatusText(state),
                                  style: TextStyle(
                                    color: _getAuthColor(state),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getAuthColor(AppState state) {
    switch (state.currentRole) {
      case UserRole.customer:
        return state.isCustomerRegistered
            ? AppColors.accent
            : AppColors.primaryLight;
      case UserRole.trainer:
        return state.isTrainerRegistered ? AppColors.accent : AppColors.warning;
      case UserRole.admin:
        return state.isAdminRegistered ? AppColors.accent : AppColors.error;
      case UserRole.support:
        return state.isSupportRegistered ? AppColors.accent : AppColors.warning;
    }
  }

  IconData _getAuthIcon(AppState state) {
    switch (state.currentRole) {
      case UserRole.customer:
        return state.isCustomerRegistered
            ? Icons.check_circle_outline
            : Icons.explore_outlined;
      case UserRole.trainer:
        return state.isTrainerRegistered ? Icons.verified : Icons.lock_outline;
      case UserRole.admin:
        return state.isAdminRegistered
            ? Icons.admin_panel_settings
            : Icons.lock_outline;
      case UserRole.support:
        return state.isSupportRegistered
            ? Icons.headset_mic
            : Icons.lock_outline;
    }
  }

  String _getAuthStatusText(AppState state) {
    switch (state.currentRole) {
      case UserRole.customer:
        return state.isCustomerRegistered
            ? 'Registered User'
            : 'Guest (Free Browse)';
      case UserRole.trainer:
        return state.isTrainerRegistered ? 'Trainer Active' : 'Login Required';
      case UserRole.admin:
        return state.isAdminRegistered
            ? 'Admin Console'
            : 'Restricted (Login Req)';
      case UserRole.support:
        return state.isSupportRegistered ? 'Support Active' : 'Login Required';
    }
  }

  DropdownMenuItem<UserRole> _roleItem(
    UserRole role,
    IconData icon,
    String label,
  ) {
    return DropdownMenuItem<UserRole>(
      value: role,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryLight),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
