import 'package:flutter/material.dart';
import '../services/recommendation_api.dart';

class ModelRecommendationsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  const ModelRecommendationsScreen({super.key, required this.transactions});

  @override
  State<ModelRecommendationsScreen> createState() => _ModelRecommendationsScreenState();
}

class _ModelRecommendationsScreenState extends State<ModelRecommendationsScreen> {
  final Color primaryGreen = Color(0xFF63A50D);
  final Color primaryRed = Colors.redAccent;

  // Sample Data (would come from your AI model)
  late final double predictedMonthlySpending = 950000; // Placeholder until model feedback
  late double currentMonthlyExpenses = 0;
  late double monthlyBudget = 0;

  // Backend base URL. For Android emulator use 10.0.2.2, for iOS sim use localhost.
  static const String apiBaseUrl = 'http://10.0.2.2:8000';
  late final RecommendationApiService _api = RecommendationApiService(baseUrl: apiBaseUrl);

  bool _loading = false;
  int? _recommendFlag;
  String? _error;

  @override
  void initState() {
    super.initState();
    _computeAggregates();
  }

  void _computeAggregates() {
    final DateTime now = DateTime.now();
    double income = 0;
    double expenses = 0;
    for (final tx in widget.transactions) {
      try {
        final DateTime d = DateTime.parse((tx['date'] ?? '').toString());
        if (d.year == now.year && d.month == now.month) {
          final String type = (tx['type'] ?? '').toString();
          final double amount = (tx['amount'] as num).toDouble();
          if (type == 'Income') {
            income += amount;
          } else if (type.startsWith('Expense')) {
            expenses += amount;
          }
        }
      } catch (_) {}
    }
    setState(() {
      currentMonthlyExpenses = expenses;
      monthlyBudget = income; // Treat income as budget
    });
  }

  @override
  Widget build(BuildContext context) {
    bool onTrack = predictedMonthlySpending <= monthlyBudget;
    String statusMessage = onTrack ? 'On Track to Stay Within Budget' : 'Likely to Exceed Budget';
    Color statusColor = onTrack ? primaryGreen : primaryRed;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('AI Recommendations', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Predicted Spending Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Predicted Monthly Spending',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rwf ${predictedMonthlySpending.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen),
                    ),
                    SizedBox(height: 5),
                    Text(
                      statusMessage,
                      style: TextStyle(fontSize: 16, color: statusColor, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: currentMonthlyExpenses / monthlyBudget.clamp(1, double.infinity), // Current vs Budget
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(onTrack ? primaryGreen : primaryRed),
                      borderRadius: BorderRadius.circular(5),
                      minHeight: 10,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current: Rwf ${currentMonthlyExpenses.toStringAsFixed(0)}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        Text('Budget: Rwf ${monthlyBudget.toStringAsFixed(0)}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _loading ? null : _onGetRecommendation,
                          style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                          icon: _loading
                              ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Icon(Icons.insights, color: Colors.white),
                          label: Text('Get Recommendation', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 12),
                        if (_recommendFlag != null)
                          Chip(
                            label: Text('Flag: $_recommendFlag'),
                            backgroundColor: primaryGreen.withOpacity(0.1),
                            labelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(_error!, style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Top Savings Opportunities
            Text(
              'Top Savings Opportunities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 15),
            _buildRecommendationCard(
              context,
              'Reduce Dining Out by Rwf 50,000',
              'Based on your spending, cutting down on restaurant visits could save you Rwf 600,000 annually!',
              Icons.restaurant_menu,
              primaryGreen,
            ),
            _buildRecommendationCard(
              context,
              'Optimize Subscriptions',
              'You have 3 inactive subscriptions. Cancelling them could save Rwf 25,000 monthly.',
              Icons.subscriptions,
              Colors.purpleAccent,
            ),
            _buildRecommendationCard(
              context,
              'Cut Impulse Buys',
              'Your "Shopping" category shows Rwf 40,000 in unplanned purchases. Try a 24-hour rule.',
              Icons.shopping_bag,
              Colors.orangeAccent,
            ),
            SizedBox(height: 30),

            // What If Scenarios
            Text(
              'What If Scenarios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 15),
            _buildWhatIfCard(context, 'Dining', 10000, primaryGreen),
            _buildWhatIfCard(context, 'Transport', 5000, Colors.blueAccent),
            SizedBox(height: 30),

            // Future Projections (Optional section)
            Text(
              'Future Projections',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 15),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Long-Term Spending Trend',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your current spending trend suggests you\'ll reach your "Emergency Fund" goal 3 months faster if you implement the top savings tips.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to a detailed projections screen or history
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('View detailed projections')));
                        },
                        child: Text('View Details >', style: TextStyle(color: primaryGreen)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onGetRecommendation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Map real values from transactions. Simple example encoding.
      final double incomeX = monthlyBudget * 0.7;
      final double incomeY = monthlyBudget * 0.3;
      final double totalExpenses = currentMonthlyExpenses;
      final double expenseRatio = monthlyBudget == 0 ? 0 : (currentMonthlyExpenses / monthlyBudget);
      final int riskFlag = expenseRatio > 0.8 ? 1 : 0;

      // Last expense as the sample item context
      Map<String, dynamic>? lastExpense;
      for (final tx in widget.transactions.reversed) {
        final String type = (tx['type'] ?? '').toString();
        if (type.startsWith('Expense')) { lastExpense = tx; break; }
      }
      final double expenseAmount = lastExpense != null ? (lastExpense['amount'] as num).toDouble() : 0.0;
      final String category = (lastExpense != null ? (lastExpense['category'] ?? 'Other') : 'Other').toString();
      final String priorityFlag = _priorityFlagFromType((lastExpense != null ? (lastExpense['type'] ?? '') : '').toString());
      final String currency = 'Rwf';
      final double cutoffRate = 0.1;

      final flag = await _api.getRecommendation(
        incomeX: incomeX,
        incomeY: incomeY,
        expenseAmount: expenseAmount,
        category: category,
        priorityFlag: priorityFlag,
        currency: currency,
        cutoffRate: cutoffRate,
        totalExpenses: totalExpenses,
        expenseRatio: expenseRatio,
        riskFlag: riskFlag,
      );

      if (!mounted) return;
      setState(() {
        _recommendFlag = flag;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recommendation flag: $flag')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  // Category encoding moved server-side; keeping client simple.

  String _priorityFlagFromType(String type) {
    if (type == 'Expense_Planned') return 'planned';
    if (type == 'Expense_Unplanned') return 'unplanned';
    return 'other';
  }

  Widget _buildRecommendationCard(BuildContext context, String title, String description, IconData icon, Color iconColor) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement "Act on this" or "Learn more"
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action for "$title"')));
                      },
                      child: Text('Act Now', style: TextStyle(color: primaryGreen)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatIfCard(BuildContext context, String category, double amountToCut, Color color) {
    double monthlyImpact = amountToCut; // Simplistic calculation for demo
    double yearlyImpact = amountToCut * 12;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What if you cut Rwf ${amountToCut.toStringAsFixed(0)} from $category?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.trending_up, color: color),
                SizedBox(width: 8),
                Text(
                  'Monthly Savings: ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  'Rwf ${monthlyImpact.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.monetization_on, color: color),
                SizedBox(width: 8),
                Text(
                  'Yearly Savings: ',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  'Rwf ${yearlyImpact.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement detailed impact analysis or goal linking
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Simulating impact for $category')));
                },
                child: Text('See Detailed Impact >', style: TextStyle(color: color)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}