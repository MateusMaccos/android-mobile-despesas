import 'package:cloud_firestore/cloud_firestore.dart';

class Transacao {
  late final String id;
  late final String title;
  late final double value;
  late final DateTime date;
  late final bool minha;

  Transacao(
      {required this.id,
      required this.title,
      required this.value,
      required this.date,
      required this.minha});

  Transacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    date = (json['date'] as Timestamp).toDate();
    minha = json['minha'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['value'] = value;
    data['date'] = date;
    data['minha'] = minha;
    return data;
  }
}
