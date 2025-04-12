import 'package:flutter/material.dart';

void main() {
  runApp(BudgetTripApp());
}

class BudgetTripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetTrip',
      home: BudgetPlanner(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Expense {
  final String category;
  final double amount;

  Expense({required this.category, required this.amount});
}

class BudgetPlanner extends StatefulWidget {
  @override
  _BudgetPlannerState createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {
  double budget = 0.0;
  final budgetController = TextEditingController();
  final amountController = TextEditingController();
  String selectedCategory = 'Accommodation';

  List<Expense> expenses = [];

  double get totalSpent =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get remaining => budget - totalSpent;

  void setTripBudget() {
    final input = double.tryParse(budgetController.text);
    if (input != null) {
      setState(() {
        budget = input;
        expenses.clear();
      });
      budgetController.clear();
    }
  }

  void addExpense() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      expenses.add(Expense(category: selectedCategory, amount: amount));
      amountController.clear();
    });
  }

  double categoryTotal(String category) {
    return expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Accommodation',
      'Food',
      'Transport',
      'Activities',
      'Other'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('BudgetTrip'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {
              budget = 0;
              expenses.clear();
            }),
            tooltip: 'Reset All',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Budget Input
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Set Trip Budget (\$)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: setTripBudget, child: Text('Set Budget')),
            Divider(height: 30),

            // Expense Input
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items: categories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedCategory = value!),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addExpense,
                )
              ],
            ),
            SizedBox(height: 10),

            // Budget Summary
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Budget: \$${budget.toStringAsFixed(2)}'),
                  Text('Spent: \$${totalSpent.toStringAsFixed(2)}'),
                  Text('Remaining: \$${remaining.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: remaining < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),

            SizedBox(height: 15),

            // Category Breakdown
            Expanded(
              child: ListView(
                children: categories
                    .map(
                      (cat) => ListTile(
                        title: Text(cat),
                        trailing: Text(
                            '\$${categoryTotal(cat).toStringAsFixed(2)}'),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
