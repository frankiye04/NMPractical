import 'package:flutter/material.dart';

void main() {
  runApp(MoneySaverApp());
}

class MoneySaverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneySaver',
      home: ExpenseTracker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Expense {
  String title;
  double amount;

  Expense({required this.title, required this.amount});
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  List<Expense> expenses = [];
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void addExpense() {
    String title = titleController.text.trim();
    double? amount = double.tryParse(amountController.text);

    if (title.isEmpty || amount == null) return;

    setState(() {
      expenses.add(Expense(title: title, amount: amount));
      titleController.clear();
      amountController.clear();
    });
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  double get total {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MoneySaver'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() => expenses.clear()),
            tooltip: 'Reset All',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Spent: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Expense Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount (\$)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addExpense,
              child: Text('Add Expense'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: expenses.isEmpty
                  ? Center(child: Text('No expenses yet.'))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          child: ListTile(
                            title: Text(expense.title),
                            subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteExpense(index),
                            ),
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
