import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.t,
    required this.onRemove,
  }) : super(key: key);

  final Transacao t;
  final void Function(String p1) onRemove;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.t.minha ? Colors.white : Colors.amber,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text(
              'R\$${widget.t.value.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
        title: Text(
          widget.t.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(DateFormat('d MMM y').format(widget.t.date)),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton.icon(
                onPressed: () => widget.onRemove(widget.t.id),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                label: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.redAccent),
                ))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () => widget.onRemove(widget.t.id),
              ),
      ),
    );
  }
}
