import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/models/trainer_model.dart';
import '../../core/models/booking_model.dart';
import 'booking_success_view.dart';

class BookingFlowView extends StatefulWidget {
  final TrainerModel trainer;
  final ServiceOffering service;

  const BookingFlowView({
    super.key,
    required this.trainer,
    required this.service,
  });

  @override
  State<BookingFlowView> createState() => _BookingFlowViewState();
}

class _BookingFlowViewState extends State<BookingFlowView> {
  int _currentStep = 0;

  // Step 1: Service selection
  late ServiceOffering _selectedService;

  // Step 2: Date & Slot
  late DateTime _selectedDate;
  String _selectedSlot = '07:00 AM - 08:00 AM';
  final List<String> _availableSlots = [
    '06:00 AM - 07:00 AM',
    '07:00 AM - 08:00 AM',
    '08:30 AM - 09:30 AM',
    '05:00 PM - 06:00 PM',
    '06:30 PM - 07:30 PM',
  ];

  // Step 3: Location
  String _locationType = 'Customer Home';
  final TextEditingController _addressCtrl = TextEditingController(
    text: 'Flat 402, Prestige Palms, 12th Main Road, Indiranagar, Bengaluru',
  );

  // Step 4: Promo code
  final TextEditingController _promoCtrl = TextEditingController();
  String? _appliedPromo;
  double _promoDiscount = 0.0;
  String? _promoMessage;

  // Step 5: Payment method
  String _paymentMethod = 'UPI (Google Pay)';

  // Slot hold timer (10 minutes countdown simulation)
  Timer? _holdTimer;
  int _holdSecondsRemaining = 600; // 10 minutes

  @override
  void initState() {
    super.initState();
    _selectedService = widget.service;
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _startHoldTimer();
  }

  void _startHoldTimer() {
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_holdSecondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _holdSecondsRemaining--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _addressCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo(AppState state) {
    final code = _promoCtrl.text.trim().toUpperCase();
    final promo = state.platformSettings.promoCodes.cast<dynamic>().firstWhere(
          (p) => p.code == code,
          orElse: () => null,
        );

    if (promo != null) {
      final discount = promo.calculateDiscount(_selectedService.priceInr);
      setState(() {
        _appliedPromo = code;
        _promoDiscount = discount;
        _promoMessage = 'Code applied! You saved ${Formatters.formatINR(discount)}';
      });
    } else {
      setState(() {
        _appliedPromo = null;
        _promoDiscount = 0.0;
        _promoMessage = 'Invalid code. Try "FITFIRST" or "HEALTHY10".';
      });
    }
  }

  PriceBreakdown _calculatePrice(AppState state) {
    return PriceBreakdown.calculate(
      basePrice: _selectedService.priceInr,
      platformFeePercent: state.platformSettings.platformCommissionPercent,
      travelFee: _selectedService.travelSurchargeInr,
      discountAmount: _promoDiscount,
    );
  }

  void _completeBooking(AppState state) {
    final price = _calculatePrice(state);
    final newBooking = BookingModel(
      id: 'BK_IND_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      trainerId: widget.trainer.id,
      trainerName: widget.trainer.name,
      trainerPhoto: widget.trainer.photoUrl,
      customerId: state.currentUser.id,
      customerName: state.currentUser.name,
      customerPhone: state.currentUser.phone,
      serviceTitle: _selectedService.title,
      serviceCategory: _selectedService.category,
      durationMinutes: _selectedService.durationMinutes,
      scheduledDate: _selectedDate,
      timeSlot: _selectedSlot,
      locationAddress: _addressCtrl.text.trim(),
      locationType: _locationType,
      price: price,
      status: widget.trainer.instantBookingEnabled ? BookingStatus.confirmed : BookingStatus.pendingAcceptance,
      paymentMethod: _paymentMethod,
      paymentTransactionId: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      promoCodeApplied: _appliedPromo,
    );

    state.createBooking(newBooking);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessView(booking: newBooking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDesktop = Responsive.isDesktop(context);
    final price = _calculatePrice(state);

    final timerMin = _holdSecondsRemaining ~/ 60;
    final timerSec = (_holdSecondsRemaining % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Session'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Container(
            color: AppColors.primary.withOpacity(0.12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(
                  'Slot reserved for $timerMin:$timerSec. Complete payment to secure.',
                  style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 20,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: _buildStepsContent(context, state),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 4,
                        child: _buildPriceSummarySidebar(context, state, price),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildStepsContent(context, state),
                              const SizedBox(height: 20),
                              _buildPriceSummarySidebar(context, state, price),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepsContent(BuildContext context, AppState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trainer summary banner
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(widget.trainer.photoUrl),
                  onBackgroundImageError: (_, __) {},
                  child: Text(widget.trainer.name[0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.trainer.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 16, color: AppColors.accent),
                        ],
                      ),
                      Text(
                        '${widget.trainer.city} • ${widget.trainer.headline}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Step Indicator Tabs
            Row(
              children: [
                _stepTab(0, '1. Service & Slot'),
                const SizedBox(width: 8),
                _stepTab(1, '2. Training Address'),
                const SizedBox(width: 8),
                _stepTab(2, '3. Payment & Pay'),
              ],
            ),
            const SizedBox(height: 20),

            if (_currentStep == 0) _buildStep1ServiceAndSlot(),
            if (_currentStep == 1) _buildStep2Location(),
            if (_currentStep == 2) _buildStep3Payment(state),
          ],
        ),
      ),
    );
  }

  Widget _stepTab(int stepIndex, String title) {
    final isCurrent = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentStep = stepIndex;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isCurrent
                    ? AppColors.primary
                    : isDone
                        ? AppColors.accent
                        : AppColors.borderDark,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              color: isCurrent
                  ? Colors.white
                  : isDone
                      ? AppColors.accent
                      : AppColors.textDarkMuted,
            ),
          ),
        ),
      ),
    );
  }

  // --- Step 1: Select Service & Time Slot ---
  Widget _buildStep1ServiceAndSlot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Service Format',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ...widget.trainer.services.map((srv) {
          final isSelected = _selectedService.id == srv.id;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedService = srv;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceDarkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primaryLight : AppColors.borderDark,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.primaryLight : AppColors.textDarkMuted,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          srv.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                        ),
                        Text(
                          '${srv.durationMinutes} mins • ${srv.sessionType}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Formatters.formatINR(srv.priceInr),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),

        const Text(
          'Select Date',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (i) {
              final d = DateTime.now().add(Duration(days: i + 1));
              final isSelected = _selectedDate.day == d.day && _selectedDate.month == d.month;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = d;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceDarkCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : AppColors.borderDark,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Formatters.formatDate(d).substring(0, 3).toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textDarkMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Select Available Time Slot',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableSlots.map((slot) {
            final isSelected = _selectedSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedSlot = slot;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            child: const Text('Continue to Address'),
          ),
        ),
      ],
    );
  }

  // --- Step 2: Training Address ---
  Widget _buildStep2Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Training Location Type',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _locTypeChoice('Customer Home', Icons.home),
            const SizedBox(width: 10),
            _locTypeChoice('Apartment Clubhouse Gym', Icons.apartment),
            const SizedBox(width: 10),
            _locTypeChoice('Nearby Public Park', Icons.park),
          ],
        ),
        const SizedBox(height: 16),

        const Text(
          'Complete Address & Directions',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _addressCtrl,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Enter complete flat/villa number, society name, street, pincode',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: 12),

        // Travel coverage calculation notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Address is within trainer\'s ${widget.trainer.maxTravelRadiusKm.toInt()} km service radius in ${widget.trainer.city}. Standard travel fee of ${Formatters.formatINR(_selectedService.travelSurchargeInr)} applies.',
                  style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_addressCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your training address.')),
                  );
                  return;
                }
                setState(() => _currentStep = 2);
              },
              child: const Text('Continue to Payment'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locTypeChoice(String title, IconData icon) {
    final isSelected = _locationType == title;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _locationType = title),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryLight : AppColors.borderDark,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primaryLight : AppColors.textDarkMuted, size: 20),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Step 3: Payment Simulation ---
  Widget _buildStep3Payment(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Option',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Secured by Razorpay. Funds held securely until session completion.',
          style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
        ),
        const SizedBox(height: 12),

        _paymentOption('UPI (Google Pay)', Icons.account_balance_wallet, 'Instant UPI payment via GPay'),
        _paymentOption('UPI (PhonePe / Paytm)', Icons.qr_code, 'UPI ID or app redirection'),
        _paymentOption('Credit / Debit Card', Icons.credit_card, 'Visa, Mastercard, RuPay cards'),
        _paymentOption('NetBanking', Icons.account_balance, 'HDFC, ICICI, SBI, Axis, Kotak'),
        const SizedBox(height: 20),

        // Terms acknowledgment
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkCard,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.accent, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'By proceeding, you agree to the 4-hour cancellation terms and trainer code of conduct.',
                  style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _currentStep = 1),
              child: const Text('Back'),
            ),
            ElevatedButton.icon(
              onPressed: () => _completeBooking(state),
              icon: const Icon(Icons.lock_outline, size: 16),
              label: Text('Pay ${Formatters.formatINR(_calculatePrice(state).totalAmount)} & Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentOption(String title, IconData icon, String subtitle) {
    final isSelected = _paymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = title),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceDarkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.borderDark,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryLight : AppColors.textDarkMuted,
              size: 18,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Sticky Price Summary Sidebar ---
  Widget _buildPriceSummarySidebar(BuildContext context, AppState state, PriceBreakdown price) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Summary',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(_selectedService.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text('${_selectedService.durationMinutes} mins • ${Formatters.formatDate(_selectedDate)}', style: const TextStyle(fontSize: 12, color: AppColors.primaryLight)),
            Text('Slot: $_selectedSlot', style: const TextStyle(fontSize: 12, color: AppColors.accent)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Promo Code input
            const Text('Promo Code / Referral', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Enter FITFIRST',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _applyPromo(state),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
            if (_promoMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                _promoMessage!,
                style: TextStyle(
                  fontSize: 11,
                  color: _appliedPromo != null ? AppColors.accent : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),

            // Price Itemization
            _priceRow('Trainer Base Fee', Formatters.formatINR(price.basePrice)),
            _priceRow('Travel Surcharge', Formatters.formatINR(price.travelFee)),
            _priceRow('Platform Convenience Fee (${state.platformSettings.platformCommissionPercent.toInt()}%)', Formatters.formatINR(price.platformFee)),
            if (price.discountAmount > 0)
              _priceRow('Coupon Discount ($_appliedPromo)', '-${Formatters.formatINR(price.discountAmount)}', color: AppColors.accent),
            _priceRow('GST (18% Govt Tax)', Formatters.formatINR(price.gstAmount)),
            const Divider(height: 20),
            _priceRow('Total Payable', Formatters.formatINR(price.totalAmount), isBold: true, color: Colors.white, fontSize: 18),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceDarkCard,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock, size: 12, color: AppColors.accent),
                  SizedBox(width: 6),
                  Text(
                    '256-Bit SSL Encrypted Razorpay Checkout',
                    style: TextStyle(fontSize: 10, color: AppColors.textDarkMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false, Color? color, double fontSize = 12}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, color: AppColors.textDarkSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

