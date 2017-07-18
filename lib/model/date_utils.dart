DateTime dateTimeFromString(String stringDateTime) {
  if (stringDateTime != null) {
    return DateTime.parse(stringDateTime);
  } else {
    return null;
  }
}
