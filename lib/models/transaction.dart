import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
      'date': date,
    };
  }

  Transaction.porDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    title = doc.data()!['title'];
    value = doc.data()!['value'];
    date = doc.data()!['date'];
  }
}
