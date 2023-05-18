String formatDate(DateTime timeStamp) {
  int dayDifference = DateTime.now().difference(timeStamp).inDays;

  if (dayDifference < 1) {
    return 'h:mm a';
  } else if (dayDifference < 7) {
    return 'EEE';
  } else if (dayDifference < 30) {
    return 'EEE d';
  } else {
    return 'MMM d, yyyy';
  }
}
