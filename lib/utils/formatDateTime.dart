import 'package:intl/intl.dart';

String formatDate(String dateString) {
  // Parse the string into a DateTime object
  DateTime date = DateTime.parse(dateString);

  // Format the date in the desired format (yyyy-MM-dd)
  String formattedDate = DateFormat('yyyy.MM.dd').format(date);

  // Return the formatted date string
  return formattedDate;
}
