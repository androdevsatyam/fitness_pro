import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatINR(num amount) {
    return _inrFormatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  static String formatPhone(String phone) {
    if (phone.startsWith('+91')) return phone;
    return '+91 $phone';
  }
}

