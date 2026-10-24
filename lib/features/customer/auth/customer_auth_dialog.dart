import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';

class CustomerAuthDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  final String? initialTrainerName;
  const CustomerAuthDialog({
    super.key,
    required this.onSuccess,
    this.initialTrainerName,
  });
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSuccess,
    String? trainerName,
  }) => showDialog(
    context: context,
    builder: (_) => CustomerAuthDialog(
      onSuccess: onSuccess,
      initialTrainerName: trainerName,
    ),
  );
  @override
  State<CustomerAuthDialog> createState() => _CustomerAuthDialogState();
}

class _CustomerAuthDialogState extends State<CustomerAuthDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _register = true;
  bool _codeRequested = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_codeRequested) {
      if ((_register && _name.text.trim().isEmpty) ||
          !RegExp(r'^[6-9][0-9]{9}$').hasMatch(_phone.text.trim())) {
        setState(
          () => _error =
              'Enter ${_register ? 'your name and ' : ''}a valid 10-digit mobile number.',
        );
        return;
      }
      setState(() {
        _codeRequested = true;
        _error = null;
      });
      return;
    }
    if (_otp.text.trim() != '4589') {
      setState(() => _error = 'Enter the demo code 4589 to continue.');
      return;
    }
    final state = context.read<AppState>();
    state.registerCustomer(
      name: _register
          ? _name.text.trim()
          : (state.currentUser.phone == _phone.text.trim()
                ? state.currentUser.name
                : 'HomeFit member'),
      phone: _phone.text.trim(),
      city: 'Gurugram',
    );
    Navigator.pop(context);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(20),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'A little hello.',
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 32),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _codeRequested
                  ? 'Enter your code to continue.'
                  : widget.initialTrainerName == null
                  ? 'Your sessions and preferences, in one place.'
                  : 'Sign in to book your session with ${widget.initialTrainerName}.',
            ),
            const SizedBox(height: 28),
            if (!_codeRequested) ...[
              if (_register) ...[
                TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: 'Your name'),
                ),
                const SizedBox(height: 18),
              ],
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                decoration: const InputDecoration(
                  labelText: 'Mobile number',
                  prefixText: '+91 ',
                  counterText: '',
                ),
              ),
            ] else ...[
              Text(
                '+91 ${_phone.text.trim()}',
                style: const TextStyle(color: AppColors.ink),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _otp,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Verification code',
                  helperText: 'Mock login: use 4589. No SMS is sent.',
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _codeRequested = false;
                  _error = null;
                }),
                child: const Text('Change mobile number'),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continue,
                child: Text(_codeRequested ? 'Verify & continue' : 'Continue'),
              ),
            ),
            if (!_codeRequested) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => setState(() {
                    _register = !_register;
                    _error = null;
                  }),
                  child: Text(
                    _register
                        ? 'Already have an account? Log in'
                        : 'New here? Create an account',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
