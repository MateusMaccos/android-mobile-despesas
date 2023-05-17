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
  static const colors = [
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
  ];

  late Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    'R\$${widget.t.value.toStringAsFixed(2).replaceAll('.', ',')}')),
          ),
        ),
        title: Text(
          widget.t.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat('d MMM y').format(widget.t.date)),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton.icon(
                onPressed: () => widget.onRemove(widget.t.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  'Excluir',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.onRemove(widget.t.id),
              ),
      ),
    );
  }
}
