import 'package:intl/intl.dart';

final NumberFormat _money = NumberFormat.currency(symbol: '₱', decimalDigits: 2);

String formatMoney(double value) => _money.format(value);

String formatDate(DateTime date) => DateFormat('MMM d, y').format(date);
