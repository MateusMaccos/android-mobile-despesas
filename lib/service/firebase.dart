import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _stringTransaction = 'Transactions';

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTransaction() {
    return _db.collection(_stringTransaction).snapshots();
  }

  Future<void> addTransaction(Map<String, dynamic> dataTransaction) async {
    _db
        .collection(_stringTransaction)
        .add(dataTransaction)
        .then((value) => print('Transação Adicionada!'))
        .catchError((e) => print('Falhou, $e'));
  }
}
