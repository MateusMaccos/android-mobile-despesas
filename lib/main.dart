import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despesas/components/chart.dart';
import 'package:despesas/components/fatura_form.dart';
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
          titleLarge: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(color: Colors.white),
        ),
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
  bool inicializou = false;
  final List<Transacao> _transactions = [];
  bool _showChart = false;
  double meusGastos = 0;
  double gastosTotais = 0;

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

  _addTransaction(
    String title,
    double value,
    DateTime date,
    bool minha,
  ) {
    final newTransaction = Transacao(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
      minha: minha,
    );

    setState(() {
      FirebaseService().addTransaction(newTransaction.toJson());
    });
    Navigator.of(context).pop();
  }

  _addFatura(
    double value,
  ) {
    setState(() {
      FirebaseService().addFaturaAtual(value);
    });
    Navigator.of(context).pop();
  }

  _addTransactionByObject(Transacao transacao) {
    _transactions.add(transacao);
  }

  _deleteTransaction(String id) {
    setState(() {
      FirebaseService().deleteTransaction(id);
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

  _openFaturaFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return FaturaForm(_addFatura);
      },
    );
  }

  _carregaLista(List<DocumentSnapshot> transacoes) {
    _transactions.clear();
    for (var tr in transacoes) {
      Map<String, dynamic> infoTransacao = tr.data()! as Map<String, dynamic>;
      infoTransacao['id'] = tr.id;
      Transacao transacao = Transacao.fromJson(infoTransacao);
      _addTransactionByObject(transacao);
    }
  }

  _somaTotal() {
    double somatorio = 0;
    for (var t in _transactions) {
      somatorio += t.value;
    }
    gastosTotais = somatorio;
  }

  _somaMeusGastos() {
    double somatorio = 0;
    for (var t in _transactions) {
      if (t.minha) {
        somatorio += t.value;
      }
    }
    meusGastos = somatorio;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text('Despesas Pessoais'),
      actions: [
        IconButton(
            onPressed: () => _openFaturaFormModal(context),
            icon: const Icon(
              Icons.payment,
              color: Colors.white,
            )),
        if (isLandscape)
          IconButton(
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
              icon: Icon(
                _showChart ? Icons.list : Icons.show_chart,
                color: Colors.white,
              )),
        IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ],
    );
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseService().streamTransaction(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                  appBar: appBar,
                  body: const Center(child: CircularProgressIndicator()));
            default:
              if (snapshot.hasError) {
                return const Text('Algum erro ocorreu!');
              }
              List<DocumentSnapshot<Map<String, dynamic>>> transactionDocs =
                  snapshot.data!.docs;
              _carregaLista(transactionDocs);
              _somaMeusGastos();
              _somaTotal();
              return Scaffold(
                appBar: appBar,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(20),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Resumo",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Mateus: $meusGastos"),
                                Text("Ariadna: ${gastosTotais - meusGastos}"),
                                Text("Total: $gastosTotais"),
                                const Divider(),
                                StreamBuilder(
                                  stream: FirebaseService().getFaturaAtual(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return const LinearProgressIndicator();
                                      default:
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Algum erro ocorreu!');
                                        }
                                        Map<String, dynamic> dadosDaFatura =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        double fatura = dadosDaFatura['Valor'];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Fatura: $fatura"),
                                            Text(
                                                "Fatura-Ariadna: ${fatura - gastosTotais - meusGastos}"),
                                          ],
                                        );
                                    }
                                  },
                                ),
                              ],
                            )),
                      )),
                      if (_showChart || !isLandscape)
                        SizedBox(
                          height: availableHeight * (isLandscape ? 0.7 : 0.2),
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
