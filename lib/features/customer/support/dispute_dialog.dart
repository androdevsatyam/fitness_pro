import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_pro/core/state/app_state.dart';
import 'package:fitness_pro/core/theme/app_colors.dart';
import 'package:fitness_pro/core/models/booking_model.dart';
import 'package:fitness_pro/core/models/support_model.dart';
import 'package:fitness_pro/core/utils/formatters.dart';

class DisputeDialog extends StatefulWidget {
  final BookingModel booking;
  const DisputeDialog({super.key, required this.booking});

  @override
  State<DisputeDialog> createState() => _DisputeDialogState();
}

class _DisputeDialogState extends State<DisputeDialog> {
  String _category = 'Trainer Late / No-Show';
  final TextEditingController _descCtrl = TextEditingController(
    text:
        'Trainer arrived 30 minutes late and could not complete the full session due to a scheduling clash.',
  );
  late double _refundAmount;

  final List<String> _categories = [
    'Trainer Late / No-Show',
    'Session Quality & Incomplete Time',
    'Safety or Behavioral Concern',
    'Equipment Not Provided',
    'Other Dispute',
  ];

  @override
  void initState() {
    super.initState();
    _refundAmount = widget.booking.price.totalAmount;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  void _submitDispute(AppState state) {
    if (_descCtrl.text.trim().isEmpty) return;

    final ticket = SupportTicketModel(
      id: 'TCK_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      bookingId: widget.booking.id,
      customerName: widget.booking.customerName,
      trainerName: widget.booking.trainerName,
      category: _category,
      description: _descCtrl.text.trim(),
      priority: _category.contains('Safety')
          ? TicketPriority.urgent
          : TicketPriority.high,
      status: TicketStatus.open,
      createdAt: DateTime.now(),
      requestedRefundInr: _refundAmount,
    );

    state.createSupportTicket(ticket);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dispute reported. Support case escalated to resolution desk.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Report Issue / Dispute Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),

              const Text(
                'Issue Category',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: AppColors.surfaceDark,
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, style: const TextStyle(fontSize: 13)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 14),

              const Text(
                'Explain What Happened',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Please detail any punctuality or safety issues...',
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Requested Refund Amount',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                  Text(
                    Formatters.formatINR(_refundAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDarkCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Our Customer Support team and Platform Admin will review booking logs, arrival check-in data, and chat history.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textDarkMuted,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _submitDispute(state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                    ),
                    child: const Text('File Dispute Ticket'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
