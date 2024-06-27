import 'package:despesas/components/transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transacao> _transactions;
  final void Function(String) onRemove;

  const TransactionList(this._transactions, this.onRemove, {super.key});

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Nenhuma transação cadastrada',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final t = _transactions[index];
              return TransactionItem(
                key: GlobalObjectKey(t),
                t: t,
                onRemove: onRemove,
              );
            },
          );
    /* ListView(
            children: _transactions.map((t) {
            return TransactionItem(
              key: ValueKey(t.id),
              t: t,
              onRemove: onRemove,
            );
          }).toList()); */
  }
}
