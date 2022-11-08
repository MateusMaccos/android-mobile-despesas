class Transaction {
  late final String id;
  late final String title;
  late final double value;
  late final DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.value,
      required this.date});
}
