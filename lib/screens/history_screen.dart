import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class HistoryScreen extends StatefulWidget {
  // You might want to pass your transactions list to this screen
  // For simplicity, we'll use a copy of the transactions from IncomeExpensesScreen
  final List<Map<String, dynamic>> allTransactions;

  HistoryScreen({required this.allTransactions});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Color primaryGreen = Color(0xFF63A50D);
  final Color primaryRed = Colors.redAccent;

  DateTime _selectedMonth = DateTime.now(); // Default to current month
  bool _showAllRecords = true; // State to toggle between month filter and all records

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on selected month or show all
    List<Map<String, dynamic>> displayedTransactions = [];
    if (_showAllRecords) {
      displayedTransactions = widget.allTransactions;
    } else {
      displayedTransactions = widget.allTransactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction['date']);
        return transactionDate.year == _selectedMonth.year &&
               transactionDate.month == _selectedMonth.month;
      }).toList();
    }

    // Sort transactions by date, newest first
    displayedTransactions.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Transaction History', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Show filter options (e.g., bottom sheet or dialog)
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Current Filter Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showAllRecords
                      ? 'Displaying: All Records'
                      : 'Displaying: ${DateFormat('MMMM yyyy').format(_selectedMonth)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
                TextButton.icon(
                  onPressed: () => _selectMonth(context),
                  icon: Icon(Icons.calendar_today, color: primaryGreen, size: 18),
                  label: Text(
                    _showAllRecords ? 'Select Month' : 'Change Month',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // Transaction List
          Expanded(
            child: displayedTransactions.isEmpty
                ? Center(
                    child: Text(
                      _showAllRecords ? 'No transactions recorded yet.' : 'No transactions for this month.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: displayedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = displayedTransactions[index];
                      return _buildTransactionItem(transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget to build individual transaction items (reused from IncomeExpensesScreen)
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


  // Month Picker
  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // We only care about month and year, so we can set initial/first/last day to 1
      initialDatePickerMode: DatePickerMode.year, // Starts with year view for easier month selection
    );

    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = picked;
        _showAllRecords = false; // When a month is selected, disable "All Records"
      });
    }
  }

  // Filter Options Bottom Sheet
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Filter Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.calendar_month, color: primaryGreen),
                title: Text('Filter by Month'),
                trailing: _showAllRecords ? null : Icon(Icons.check, color: primaryGreen),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _selectMonth(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.select_all, color: primaryGreen),
                title: Text('Show All Records'),
                trailing: _showAllRecords ? Icon(Icons.check, color: primaryGreen) : null,
                onTap: () {
                  setState(() {
                    _showAllRecords = true;
                  });
                  Navigator.pop(context); // Close bottom sheet
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}