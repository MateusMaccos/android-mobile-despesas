import 'package:flutter/material.dart';

class FaturaForm extends StatefulWidget {
  final void Function(double) onSubmit;
  FaturaForm(this.onSubmit, {super.key}) {
    print('Constructor FaturaForm');
  }

  @override
  // ignore: no_logic_in_create_state
  State<FaturaForm> createState() {
    print('createState FaturaForm');
    return _FaturaFormState();
  }
}

class _FaturaFormState extends State<FaturaForm> {
  final valueController = TextEditingController();

  _FaturaFormState() {
    print('Construtor _FaturaFormState');
  }

  @override
  void initState() {
    super.initState();
    print('initState() _FaturaFormState');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() _FaturaFormState');
  }

  @override
  didUpdateWidget(FaturaForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() _TransactionFormState');
  }

  _submitForm() {
    final value = double.tryParse(valueController.text) ?? 0.0;

    widget.onSubmit(value);
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
                controller: valueController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: _submitForm,
                    child: Text(
                      'Adicionar Fatura',
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
