import 'package:flutter/material.dart';

void main() {
  runApp(SpendTrackApp());
}

class SpendTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendTrack',
      home: ExpenseTracker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Expense {
  String title;
  double amount;
  String category;

  Expense({required this.title, required this.amount, required this.category});
}

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  List<Expense> expenses = [];
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String selectedCategory = 'Food';

  void addExpense() {
    String title = titleController.text.trim();
    double? amount = double.tryParse(amountController.text);

    if (title.isEmpty || amount == null) return;

    setState(() {
      expenses.add(Expense(title: title, amount: amount, category: selectedCategory));
      titleController.clear();
      amountController.clear();
    });
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  double totalByCategory(String category) {
    return expenses
        .where((expense) => expense.category == category)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpendTrack'),
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
            // Category Selector
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Food', 'Transport', 'Entertainment', 'Utilities']
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCategory = value);
                }
              },
            ),
            SizedBox(height: 10),
            // Expense Input
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

            // Category-wise Summary
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Column(
                children: ['Food', 'Transport', 'Entertainment', 'Utilities']
                    .map((category) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '$category: \$${totalByCategory(category).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),

            // Expense List
            Expanded(
              child: expenses.isEmpty
                  ? Center(child: Text('No expenses added yet.'))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          child: ListTile(
                            title: Text(expense.title),
                            subtitle: Text('${expense.category} - \$${expense.amount.toStringAsFixed(2)}'),
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
