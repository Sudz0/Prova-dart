import 'package:intl/intl.dart';
import 'expense_model.dart';

class ExpenseController {
  final List<Expense> _expenses = [];
  double _balance = 0.0; // Variável para armazenar o saldo

  List<Expense> get expenses => _expenses;
  double get balance => _balance; // Getter para obter o saldo

  void addExpense(String description, double amount, DateTime date) {
    _expenses.add(Expense(description: description, date: date, amount: amount));
    _balance -= amount; // reduz o valor da despesa do saldo
  }

  void removeExpense(int index) {
    //remover a despesa
    _expenses.removeAt(index);
  }

  // Adicionar dinheiro ao saldo
  void addMoney(double amount) {
    _balance += amount;
  }


  double calculateTotalExpenses(DateTime date, {String? period}) {
    double total = 0.0;

    for (var expense in _expenses) {
      bool samePeriod = false;
      if (period == 'dia') { // calcula o resumo gasto por dia
        samePeriod = DateFormat.yMd().format(expense.date) == DateFormat.yMd().format(date);
      } else if (period == 'mes') { // calcula o resumo gasto por mes
        samePeriod = expense.date.year == date.year && expense.date.month == date.month;
      } else if (period == 'ano') { // calcula o resumo gasto por ano
        samePeriod = expense.date.year == date.year;
      }

      if (samePeriod || period == null) {
        total += expense.amount;
      }
    }

    return total;
  }
}
