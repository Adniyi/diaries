// Converts Date Object into the format ddmmyyyy
String formatteddate(DateTime createdAt) {
  var dd = createdAt.day.toString().padLeft(2, '0');
  var mm = createdAt.month.toString().padLeft(2, '0');
  var yyyy = createdAt.year.toString();
  return "$dd/$mm/$yyyy";
}
