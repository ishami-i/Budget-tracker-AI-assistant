import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(List<Map<String, dynamic>>) onTransactionsUpdated;

  const ProfileScreen({super.key, required this.transactions, required this.onTransactionsUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryGreen = const Color(0xFF63A50D);

  String userName = 'John Doe';
  String email = 'john@example.com';
  String currency = 'Rwf';
  double monthlyIncomeSetting = 1000000;
  double savingsGoalPercent = 20;
  bool overspendAlerts = true;
  bool savingsReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: primaryGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('User Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: TextEditingController(text: userName),
                    onChanged: (v) => userName = v,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: TextEditingController(text: email),
                    onChanged: (v) => email = v,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: currency,
                    items: const [
                      DropdownMenuItem(value: 'Rwf', child: Text('Rwf')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    ],
                    onChanged: (v) => setState(() => currency = v ?? 'Rwf'),
                    decoration: const InputDecoration(labelText: 'Currency'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Financial Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: Text('Monthly Income')),
                      SizedBox(
                        width: 140,
                        child: TextField(
                          decoration: const InputDecoration(prefixText: 'Rwf '),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: monthlyIncomeSetting.toStringAsFixed(0)),
                          onChanged: (v) => monthlyIncomeSetting = double.tryParse(v) ?? monthlyIncomeSetting,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: Text('Savings Goal %')),
                      SizedBox(
                        width: 140,
                        child: TextField(
                          decoration: const InputDecoration(suffixText: '%'),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: savingsGoalPercent.toStringAsFixed(0)),
                          onChanged: (v) => savingsGoalPercent = double.tryParse(v) ?? savingsGoalPercent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: overspendAlerts,
                    onChanged: (v) => setState(() => overspendAlerts = v),
                    title: const Text('Alerts for overspending'),
                  ),
                  SwitchListTile(
                    value: savingsReminders,
                    onChanged: (v) => setState(() => savingsReminders = v),
                    title: const Text('Reminders for savings goals'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved')));
              },
              child: const Text('Save Settings', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}



