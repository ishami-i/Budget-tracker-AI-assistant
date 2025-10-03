import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(List<Map<String, dynamic>>) onTransactionsUpdated;

  const ExpenseScreen({super.key, required this.transactions, required this.onTransactionsUpdated});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final Color primaryGreen = const Color(0xFF63A50D);
  final Color primaryRed = Colors.redAccent;

  late List<Map<String, dynamic>> _txs;
  String _priorityFilter = 'All';

  @override
  void initState() {
    super.initState();
    _txs = List<Map<String, dynamic>>.from(widget.transactions);
  }

  @override
  void didUpdateWidget(covariant ExpenseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      _txs = List<Map<String, dynamic>>.from(widget.transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _txs.where((t) => (t['type'] ?? '').toString().startsWith('Expense')).toList()
      ..sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    final filtered = _priorityFilter == 'All'
        ? expenses
        : expenses.where((t) => (t['priority_flag'] ?? 'medium') == _priorityFilter.toLowerCase()).toList();

    final Map<String, double> byCategory = {};
    for (final t in expenses) {
      final String cat = (t['category'] ?? 'Other').toString();
      byCategory[cat] = (byCategory[cat] ?? 0) + (t['amount'] as num).toDouble();
    }
    final List<_PieDatum> pie = byCategory.entries.map((e) => _PieDatum(e.key, e.value)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: primaryGreen,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        onPressed: _showAddExpense,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Priority:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _priorityFilter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'non-negotiable', child: Text('Non-negotiable')),
                  ],
                  onChanged: (v) => setState(() => _priorityFilter = v ?? 'All'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 220,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SfCircularChart(
                    legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                    series: <CircularSeries<_PieDatum, String>>[
                      PieSeries<_PieDatum, String>(
                        dataSource: pie,
                        xValueMapper: (_PieDatum d, _) => d.category,
                        yValueMapper: (_PieDatum d, _) => d.amount,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Expense List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];
                final bool isPlanned = (t['type'] ?? '') == 'Expense_Planned';
                final String priority = (t['priority_flag'] ?? 'medium').toString();
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: primaryRed.withOpacity(0.1), child: Icon(isPlanned ? Icons.receipt_long : Icons.credit_card_off, color: primaryRed)),
                    title: Text(t['description'] ?? 'Expense', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${t['category']} • ${t['date']} • ${priority.toUpperCase()}'),
                    trailing: Text('- Rwf ${(t['amount'] as num).toDouble().toStringAsFixed(0)}', style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpense() {
    final TextEditingController desc = TextEditingController();
    final TextEditingController amount = TextEditingController();
    String type = 'Expense_Planned';
    String category = 'Food';
    String priority = 'medium';
    DateTime picked = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bc) {
        return StatefulBuilder(builder: (context, setStateModal) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(value: 'Expense_Planned', child: Text('Planned')),
                      DropdownMenuItem(value: 'Expense_Unplanned', child: Text('Unplanned')),
                    ],
                    onChanged: (v) => setStateModal(() => type = v ?? 'Expense_Planned'),
                    decoration: const InputDecoration(labelText: 'Type', prefixIcon: Icon(Icons.swap_vert)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: desc,
                    decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount', prefixIcon: Icon(Icons.monetization_on)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: const [
                      DropdownMenuItem(value: 'Food', child: Text('Food')),
                      DropdownMenuItem(value: 'Housing', child: Text('Housing')),
                      DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                      DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                      DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (v) => setStateModal(() => category = v ?? 'Food'),
                    decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'non-negotiable', child: Text('Non-negotiable')),
                    ],
                    onChanged: (v) => setStateModal(() => priority = v ?? 'medium'),
                    decoration: const InputDecoration(labelText: 'Priority', prefixIcon: Icon(Icons.flag)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(picked)),
                    decoration: const InputDecoration(labelText: 'Date', prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () async {
                      final d = await showDatePicker(context: context, initialDate: picked, firstDate: DateTime(2000), lastDate: DateTime(2100));
                      if (d != null) setStateModal(() => picked = d);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                      onPressed: () {
                        final v = double.tryParse(amount.text);
                        if ((desc.text).isEmpty || v == null || v <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields correctly')));
                          return;
                        }
                        final newTx = {
                          'type': type,
                          'description': desc.text,
                          'amount': v,
                          'date': DateFormat('yyyy-MM-dd').format(picked),
                          'category': category,
                          'priority_flag': priority,
                        };
                        setState(() => _txs.add(newTx));
                        widget.onTransactionsUpdated(_txs);
                        Navigator.pop(context);
                      },
                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class _PieDatum {
  final String category;
  final double amount;
  _PieDatum(this.category, this.amount);
}



