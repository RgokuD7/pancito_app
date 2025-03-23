import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) {
    return 'hoy';
  } else if (difference == 1) {
    return 'ayer';
  } else {
    final dayOfWeek = DateFormat('EEEE', 'es_ES').format(date);
    final dayOfMonth = DateFormat('d').format(date);
    if (now.month != date.month) {
      final month = DateFormat('MMMM', 'es_ES').format(date);
      return '$dayOfWeek $dayOfMonth de $month';
    }
    return '$dayOfWeek $dayOfMonth';
  }
}
