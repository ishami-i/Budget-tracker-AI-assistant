import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class IncomeExpensesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> initialTransactions;
  final Function(List<Map<String, dynamic>>) onTransactionsUpdated;

  IncomeExpensesScreen({
    Key? key,
    required this.initialTransactions,
    required this.onTransactionsUpdated,
  }) : super(key: key);

  @override
  _IncomeExpensesScreenState createState() => _IncomeExpensesScreenState();
}

class _IncomeExpensesScreenState extends State<IncomeExpensesScreen> {
  final Color primaryGreen = Color(0xFF63A50D);
  final Color primaryRed = Colors.redAccent; // For expenses

  String _selectedTransactionType = 'All'; // For filtering transactions

  late List<Map<String, dynamic>> transactions; // Local mutable copy of transactions
  double totalMonthlyIncome = 0;
  double totalMonthlyExpenses = 0;
  double remainingBudget = 0;

  List<Map<String, dynamic>> goals = [
    {
      'name': 'Buy New Phone',
      'target': 800000.0,
      'saved': 350000.0,
      'icon': Icons.phone_android,
      'color': Colors.blueAccent,
    },
    {
      'name': 'Emergency Fund',
      'target': 2000000.0,
      'saved': 1200000.0,
      'icon': Icons.medical_services,
      'color': Colors.orangeAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize local transactions from the passed initialTransactions
    transactions = List.from(widget.initialTransactions);
    _calculateSummary();
  }

  @override
  void didUpdateWidget(covariant IncomeExpensesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent widget updates initialTransactions, refresh our local copy
    if (widget.initialTransactions != oldWidget.initialTransactions) {
      transactions = List.from(widget.initialTransactions);
      _calculateSummary();
    }
  }

  void _calculateSummary() {
    double currentMonthIncome = 0;
    double currentMonthExpenses = 0;
    DateTime now = DateTime.now();
    
    // Filter transactions for the current month only for the summary
    for (var transaction in transactions) {
      DateTime transactionDate = DateTime.parse(transaction['date']);
      if (transactionDate.year == now.year && transactionDate.month == now.month) {
        if (transaction['type'] == 'Income') {
          currentMonthIncome += transaction['amount'] as double;
        } else if (transaction['type'].startsWith('Expense')) {
          currentMonthExpenses += transaction['amount'] as double;
        }
      }
    }

    setState(() {
      totalMonthlyIncome = currentMonthIncome;
      totalMonthlyExpenses = currentMonthExpenses;
      remainingBudget = totalMonthlyIncome - totalMonthlyExpenses;
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTransactions = transactions.where((transaction) {
      // For this screen, we only show current month's transactions in the main list
      DateTime transactionDate = DateTime.parse(transaction['date']);
      DateTime now = DateTime.now();
      if (!(transactionDate.year == now.year && transactionDate.month == now.month)) {
        return false; // Only show transactions for the current month
      }

      if (_selectedTransactionType == 'All') return true;
      if (_selectedTransactionType == 'Income') return transaction['type'] == 'Income';
      if (_selectedTransactionType == 'Planned Expenses') return transaction['type'] == 'Expense_Planned';
      if (_selectedTransactionType == 'Unplanned Expenses') return transaction['type'] == 'Expense_Unplanned';
      return false;
    }).toList();

    // Sort transactions by date, newest first for the list display
    filteredTransactions.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Income & Expenses', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryGreen, // Ensure AppBar background uses primaryGreen
        elevation: 0,
        // No actions needed here as History is on BottomNavBar
      ),
      body: CustomScrollView(
        slivers: [
          // Monthly Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Month Overview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      SizedBox(height: 15),
                      _buildSummaryRow('Income', 'Rwf ${totalMonthlyIncome.toStringAsFixed(0)}', primaryGreen),
                      _buildSummaryRow('Expenses', 'Rwf ${totalMonthlyExpenses.toStringAsFixed(0)}', primaryRed),
                      Divider(height: 30),
                      _buildSummaryRow('Remaining', 'Rwf ${remainingBudget.toStringAsFixed(0)}',
                          remainingBudget >= 0 ? primaryGreen : primaryRed,
                          isBold: true),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // My Goals Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'My Goals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 160, // Fixed height for goals section
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: goals.length + 1, // +1 for "Add New Goal"
                itemBuilder: (context, index) {
                  if (index == goals.length) {
                    return _buildAddGoalCard(context);
                  }
                  final goal = goals[index];
                  return _buildGoalCard(goal);
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text(
                'This Month\'s Transactions', // Title indicates current month's transactions
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ),
          ),

          // Transaction Type Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(value: 'All', label: Text('All')),
                  ButtonSegment<String>(value: 'Income', label: Text('Income')),
                  ButtonSegment<String>(value: 'Planned Expenses', label: Text('Planned')),
                  ButtonSegment<String>(value: 'Unplanned Expenses', label: Text('Unplanned')),
                ],
                selected: <String>{_selectedTransactionType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedTransactionType = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: primaryGreen.withOpacity(0.2),
                  selectedForegroundColor: primaryGreen,
                  foregroundColor: Colors.grey[700],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = filteredTransactions[index];
                  return _buildTransactionItem(transaction);
                },
                childCount: filteredTransactions.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTransactionModal(context);
        },
        label: Text('Add Transaction'),
        icon: Icon(Icons.add),
        backgroundColor: primaryGreen,
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    double progress = (goal['saved'] / goal['target']).clamp(0.0, 1.0);
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(goal['icon'], color: goal['color'], size: 30),
              SizedBox(height: 8),
              Text(
                goal['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Rwf ${goal['saved'].toStringAsFixed(0)} / ${goal['target'].toStringAsFixed(0)}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(goal['color']),
                borderRadius: BorderRadius.circular(5),
                minHeight: 8,
              ),
              SizedBox(height: 4),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% complete',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddGoalCard(BuildContext context) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add New Goal functionality coming soon!')));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: primaryGreen.withOpacity(0.5), width: 1.5),
          ),
          color: primaryGreen.withOpacity(0.1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: primaryGreen, size: 40),
                SizedBox(height: 8),
                Text(
                  'Add New Goal',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    bool isIncome = transaction['type'] == 'Income';
    bool isPlanned = transaction['type'] == 'Expense_Planned';
    Color amountColor = isIncome ? primaryGreen : primaryRed;
    IconData icon = isIncome ? Icons.arrow_downward : (isPlanned ? Icons.receipt_long : Icons.credit_card_off);

    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(icon, color: amountColor, size: 24),
        ),
        title: Text(
          transaction['description'],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        subtitle: Text(
          '${transaction['category']} - ${transaction['date']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} Rwf ${transaction['amount'].toStringAsFixed(0)}',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('View/Edit ${transaction['description']}')));
        },
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    // Controllers for form fields
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _dateController = TextEditingController();

    String? _selectedType = 'Expense_Planned'; // Default value
    String? _selectedCategory = 'Food'; // Default value
    DateTime? _pickedDate = DateTime.now();

    _dateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate!);


    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows keyboard to push up the modal
      builder: (BuildContext bc) {
        return StatefulBuilder( // Use StatefulBuilder to update the modal's UI
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                top: 20, left: 20, right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Add New Transaction',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.swap_vert),
                      ),
                      value: _selectedType,
                      items: <String>['Income', 'Expense_Planned', 'Expense_Unplanned']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.replaceAll('_', ' ')),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateModal(() {
                          _selectedType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount (Rwf)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.monetization_on),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _selectedCategory,
                      items: <String>['Food', 'Housing', 'Transport', 'Utilities', 'Entertainment', 'Work', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateModal(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _pickedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setStateModal(() {
                            _pickedDate = picked;
                            _dateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate!);
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // Validate inputs
                          if (_selectedType == null ||
                              _descriptionController.text.isEmpty ||
                              _amountController.text.isEmpty ||
                              _selectedCategory == null ||
                              _pickedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill all fields to add a transaction.')));
                            return;
                          }

                          final double? amount = double.tryParse(_amountController.text);
                          if (amount == null || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter a valid amount.')));
                            return;
                          }

                          final newTransaction = {
                            'type': _selectedType,
                            'description': _descriptionController.text,
                            'amount': amount,
                            'date': DateFormat('yyyy-MM-dd').format(_pickedDate!),
                            'category': _selectedCategory,
                          };

                          // Add to the local list and notify parent
                          setState(() {
                            transactions.add(newTransaction);
                            _calculateSummary(); // Recalculate summary for this screen
                          });
                          widget.onTransactionsUpdated(transactions); // Notify MainScreen

                          Navigator.pop(context); // Close modal
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction Added!')));
                        },
                        child: Text(
                          'Save Transaction',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}