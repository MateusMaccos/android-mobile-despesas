import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime, bool) onSubmit;
  TransactionForm(this.onSubmit, {super.key}) {
    print('Constructor TransactionForm');
  }

  @override
  // ignore: no_logic_in_create_state
  State<TransactionForm> createState() {
    print('createState TransactionForm');
    return _TransactionFormState();
  }
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final valueController = TextEditingController();

  late DateTime? _selectedDate = DateTime.now();

  bool ativo = true;

  _TransactionFormState() {
    print('Construtor _TransactionFormState');
  }

  @override
  void initState() {
    super.initState();
    print('initState() _TransactionFormState');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() _TransactionFormState');
  }

  @override
  didUpdateWidget(TransactionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() _TransactionFormState');
  }

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate!, ativo);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return null;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data selecionada: ${DateFormat('d/M/y').format(_selectedDate!)}'),
                    ),
                    TextButton(
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showDatePicker,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Minha conta'),
                    ),
                    Switch(
                      value: ativo,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        setState(() {
                          ativo = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: _submitForm,
                    child: Text(
                      'Nova Transação',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.labelLarge?.color),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
