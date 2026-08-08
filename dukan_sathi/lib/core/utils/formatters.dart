import 'package:intl/intl.dart';

/// Formatting utility helpers for currency, date/time, and strings.
class AppFormatters {
  AppFormatters._();

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');

  /// Formats currency double value (e.g. 12.5 -> "₹12.50")
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: symbol);
    return formatter.format(amount);
  }

  /// Formats DateTime object to "07 Aug 2026"
  static String formatDate(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  /// Formats DateTime object to "07 Aug 2026, 05:30 PM"
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Formats DateTime object to "05:30 PM"
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Capitalizes first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
}

/// Convenience alias class
abstract class Formatters {
  static String currency(double amount, {String symbol = '₹'}) =>
      AppFormatters.formatCurrency(amount, symbol: symbol);

  static String date(DateTime dateTime) => AppFormatters.formatDate(dateTime);

  static String dateTime(DateTime dateTime) => AppFormatters.formatDateTime(dateTime);

  static String time(DateTime dateTime) => AppFormatters.formatTime(dateTime);

  static String capitalize(String text) => AppFormatters.capitalize(text);
}
