import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/support_model.dart';

class SupportDashboardView extends StatefulWidget {
  const SupportDashboardView({super.key});

  @override
  State<SupportDashboardView> createState() => _SupportDashboardViewState();
}

class _SupportDashboardViewState extends State<SupportDashboardView> {
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);

    final tickets = state.supportTickets.where((t) {
      if (_filterStatus == 'open') return t.status == TicketStatus.open;
      if (_filterStatus == 'resolved') return t.status == TicketStatus.resolved;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support & Grievance Console'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceDarkCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Role: Support Agent (Neha Patel)',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            tooltip: 'Sign out of Support Console',
            onPressed: () {
              state.logoutSupport();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out of Support Console')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Assigned Support Tickets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        _statusFilterChip('all', 'All Tickets'),
                        const SizedBox(width: 8),
                        _statusFilterChip('open', 'Open Cases'),
                        const SizedBox(width: 8),
                        _statusFilterChip('resolved', 'Resolved'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: tickets.isEmpty
                      ? const Center(
                          child: Text(
                            'No support tickets in this view.',
                            style: TextStyle(color: AppColors.textDarkMuted),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tickets.length,
                          itemBuilder: (context, idx) {
                            final t = tickets[idx];
                            return _buildTicketCard(context, state, t);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusFilterChip(String key, String label) {
    final isSelected = _filterStatus == key;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (_) => setState(() => _filterStatus = key),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    AppState state,
    SupportTicketModel t,
  ) {
    final isResolved = t.status == TicketStatus.resolved;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: t.priority == TicketPriority.urgent
                        ? AppColors.error.withValues(alpha: 0.15)
                        : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Priority: ${t.priority.name.toUpperCase()}',
                    style: TextStyle(
                      color: t.priority == TicketPriority.urgent
                          ? AppColors.error
                          : AppColors.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Case ID: #${t.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDarkMuted,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isResolved
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.info.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    t.status.displayName,
                    style: TextStyle(
                      color: isResolved ? AppColors.accent : AppColors.info,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              t.category,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Customer: ${t.customerName} • Assigned Trainer: ${t.trainerName}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDarkSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            if (t.requestedRefundInr > 0)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDarkCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Requested Compensation / Refund: ${Formatters.formatINR(t.requestedRefundInr)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            if (t.resolutionNotes != null) ...[
              const SizedBox(height: 10),
              Text(
                'Resolution: ${t.resolutionNotes}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isResolved) ...[
                  OutlinedButton(
                    onPressed: () {
                      state.resolveDispute(
                        t.id,
                        'Customer advised on re-booking reschedule policy.',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ticket resolved.')),
                      );
                    },
                    child: const Text('Mark Resolved (No Refund)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      state.resolveDispute(
                        t.id,
                        'Refund processed by support escalation desk.',
                        issueRefund: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Case resolved with full client refund.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    child: const Text('Resolve & Issue Refund'),
                  ),
                ] else ...[
                  const Text(
                    'Case Closed',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDarkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
