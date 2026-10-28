import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat('MMM d, y').format(date);

String formatDateTime(DateTime date) =>
    DateFormat.yMMMd().add_jm().format(date); // sampol kay Oct 28, 2026 3:45 PM
