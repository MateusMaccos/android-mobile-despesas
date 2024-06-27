import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _stringTransaction = 'Transactions';
  static const String _stringFatura = 'Fatura';

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

  Future<void> addFaturaAtual(double valor) async {
    _db
        .collection(_stringFatura)
        .add({'Valor': valor, 'Dono': 'Mateus'})
        .then((value) => print("Fatura adicionada!"))
        .catchError((e) => print('Falhou, $e'));
  }

  Future<void> deleteTransaction(String id) async {
    _db
        .collection(_stringTransaction)
        .doc(id)
        .delete()
        .then((value) => print('Transação Deletada!'))
        .catchError((e) => print('Falhou, $e'));
  }
}
