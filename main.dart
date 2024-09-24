import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense_controller.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Financeira', // para eu poder alterar as cores 
      theme: ThemeData(
        primarySwatch: Colors.amber, 
        scaffoldBackgroundColor: Colors.amber[50], 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber[700], 
          foregroundColor: Colors.white, 
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[600], 
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), 
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)), 
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(), 
      ),
      home: ExpenseHomePage(), 
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final ExpenseController _controller = ExpenseController(); 
  DateTime _selectedDate = DateTime.now(); 
  String _descricao = ''; 
  String _quantidade = ''; 

  // adiciona despesa
  void _addExpense() {
    if (_descricao.isEmpty || _quantidade.isEmpty) {
      return;
    }

    setState(() {
      _controller.addExpense(
        _descricao,
        double.parse(_quantidade),
        _selectedDate,
      );
    });

    _descricao = '';
    _quantidade = '';
  }

  // remove despesa
  void _removeExpense(int index) {
    setState(() {
      _controller.removeExpense(index);
    });
  }

  // seleciona a data das despesas
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // calcula todos gastos
  double _calculateTotalGasto() {
    return _controller.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Financeira'), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // exibição do total gasto até o momento
            Text(
              'Total Gasto: R\$ ${_calculateTotalGasto().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            
            // resumo dos gastos (por dia, mês e ano)
            Text('Resumo de Gastos:', style: TextStyle(fontSize: 16)),
            Text(
                'Hoje: R\$ ${_controller.calculateTotalExpenses(DateTime.now(), period: 'dia').toStringAsFixed(2)}'),
            Text(
                'Mês: R\$ ${_controller.calculateTotalExpenses(DateTime.now(), period: 'mes').toStringAsFixed(2)}'),
            Text(
                'Ano: R\$ ${_controller.calculateTotalExpenses(DateTime.now(), period: 'ano').toStringAsFixed(2)}'),
            SizedBox(height: 20),
            
            // adicionar uma nova despesa
            Text('Adicionar Despesa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Data: ${DateFormat.yMMMd().format(_selectedDate)}', 
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton( // calendario para a data
                  icon: Icon(Icons.calendar_today), 
                  onPressed: () => _selectDate(context), 
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descrição', 
              ),
              onChanged: (value) {
                setState(() {
                  _descricao = value; 
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Valor', 
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _quantidade = value; 
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addExpense, // adicionar despesa
              child: Text('Adicionar Despesa'),
            ),
            SizedBox(height: 20),
            
            // lista de despesas adicionadas
            Expanded(
              child: ListView.builder(
                itemCount: _controller.expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_controller.expenses[index].description), 
                    subtitle: Text(DateFormat.yMMMd().format(_controller.expenses[index].date)), 
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'R\$ ${_controller.expenses[index].amount.toStringAsFixed(2)}', 
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton( // serve para deletar as despesas
                          icon: Icon(Icons.delete), 
                          color: Colors.red,
                          onPressed: () => _removeExpense(index), 
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
