import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(List<Map<String, dynamic>>) onTransactionsUpdated;

  const IncomeScreen({super.key, required this.transactions, required this.onTransactionsUpdated});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final Color primaryGreen = const Color(0xFF63A50D);

  late List<Map<String, dynamic>> _txs;

  @override
  void initState() {
    super.initState();
    _txs = List<Map<String, dynamic>>.from(widget.transactions);
  }

  @override
  void didUpdateWidget(covariant IncomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      _txs = List<Map<String, dynamic>>.from(widget.transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final incomeTx = _txs.where((t) => t['type'] == 'Income').toList()
      ..sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    final double thisMonthIncome = incomeTx.where((t) {
      final d = DateTime.tryParse(t['date'] ?? '') ?? DateTime(2000);
      return d.year == now.year && d.month == now.month;
    }).fold(0.0, (p, t) => p + (t['amount'] as num).toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        backgroundColor: primaryGreen,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        onPressed: _showAddIncome,
        icon: const Icon(Icons.add),
        label: const Text('Add Income'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('This month', style: TextStyle(fontSize: 16)),
                    Text('Rwf ${thisMonthIncome.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text('Income History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: incomeTx.length,
              itemBuilder: (context, index) {
                final t = incomeTx[index];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: primaryGreen.withOpacity(0.1), child: Icon(Icons.savings, color: primaryGreen)),
                  title: Text(t['description'] ?? 'Income', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(t['date'] ?? ''),
                  trailing: Text('+ Rwf ${(t['amount'] as num).toDouble().toStringAsFixed(0)}',
                      style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddIncome() {
    final TextEditingController desc = TextEditingController();
    final TextEditingController amount = TextEditingController();
    DateTime picked = DateTime.now();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bc) {
        return StatefulBuilder(builder: (context, setStateModal) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Income', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
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
                        'type': 'Income',
                        'description': desc.text,
                        'amount': v,
                        'date': DateFormat('yyyy-MM-dd').format(picked),
                        'category': 'Work',
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
          );
        });
      },
    );
  }
}



