import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despesas/components/chart.dart';
import 'package:despesas/components/transaction_form.dart';
import 'package:despesas/service/firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData(primarySwatch: Colors.purple);
    return MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            button: const TextStyle(color: Colors.white)),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transacao> _transactions = [
    /* Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Conta #id',
        value: 24.56,
        date: DateTime.now()), */
  ];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Transacao> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transacao(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((t) => t.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: [
        if (isLandscape)
          IconButton(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(_showChart ? Icons.list : Icons.show_chart)),
        IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(Icons.add)),
      ],
    );
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseService().streamTransaction(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                  appBar: appBar,
                  body: const Center(child: CircularProgressIndicator()));
            default:
              List<DocumentSnapshot> TransactionDocs = snapshot.data!.docs;
              TransactionDocs.isNotEmpty
                  ? snapshot.data!.docs.map((DocumentSnapshot tr) {
                      Map<String, dynamic> dataTransaction =
                          tr.data() as Map<String, dynamic>;
                      Transacao transacao = Transacao.fromJson(dataTransaction);
                      _transactions.add(transacao);
                    })
                  : print('Documento Vazio');
              return Scaffold(
                appBar: appBar,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /* if (isLandscape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Exibir Gráfico'),
                      Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor,
                          value: _showChart,
                          onChanged: ((value) {
                            setState(() {
                              _showChart = value;
                            });
                          })),
                    ],
                  ), */
                      if (_showChart || !isLandscape)
                        SizedBox(
                          height: availableHeight * (isLandscape ? 0.7 : 0.3),
                          child: Chart(_recentTransactions),
                        ),
                      if (!_showChart || !isLandscape)
                        SizedBox(
                          height: availableHeight * (isLandscape ? 1 : 0.7),
                          child: TransactionList(
                              _transactions, _deleteTransaction),
                        )
                    ],
                  ),
                ),
                floatingActionButton: Platform.isIOS
                    ? Container()
                    : FloatingActionButton(
                        onPressed: () => _openTransactionFormModal(context),
                        child: const Icon(Icons.add),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
          }
        });
  }
}
