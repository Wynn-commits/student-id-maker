import 'package:intl/intl.dart';

// Change '₱' here if you want a different currency symbol.
final NumberFormat _money = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

String formatMoney(double value) => _money.format(value);

String formatDateTime(DateTime date) =>
    DateFormat.yMMMd().add_jm().format(date); // e.g. Oct 28, 2026 3:45 PM
