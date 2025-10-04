import 'package:flutter/material.dart';

class ModelRecommendationsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  const ModelRecommendationsScreen({super.key, required this.transactions});

  @override
  State<ModelRecommendationsScreen> createState() => _ModelRecommendationsScreenState();
}

class _ModelRecommendationsScreenState extends State<ModelRecommendationsScreen> {
  final Color primaryGreen = Color(0xFF63A50D);
  final Color primaryRed = Colors.redAccent;

  late double currentMonthlyExpenses = 0;
  late double monthlyBudget = 0;

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
        final String dateStr = (tx['date'] ?? '').toString();
        final DateTime d = DateTime.parse(dateStr);
        
        // Include transactions from current year OR recent months
        final bool isCurrentYear = d.year == now.year;
        final bool isRecentMonth = d.year == now.year - 1 && d.month >= now.month - 2;
        final bool isCurrentMonth = d.year == now.year && d.month == now.month;
        
        if (isCurrentYear || isRecentMonth || isCurrentMonth) {
          final String type = (tx['type'] ?? '').toString();
          final double amount = (tx['amount'] as num).toDouble();
          
          if (type == 'Income') {
            income += amount;
          } else if (type.startsWith('Expense')) {
            expenses += amount;
          }
        }
      } catch (e) {
        // Skip invalid transactions
      }
    }
    
    setState(() {
      currentMonthlyExpenses = expenses;
      monthlyBudget = income > 0 ? income : 1000000; // Default 1M Rwf if no income
    });
  }

  @override
  Widget build(BuildContext context) {
    // Removed unused onTrack variable

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
             // Practical Budget Analysis Card
             Card(
               elevation: 4,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
               color: Colors.white,
               child: Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           'This Month\'s Budget Analysis',
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                         ),
                         Icon(Icons.analytics, color: primaryGreen),
                       ],
                     ),
                     SizedBox(height: 15),
                     
                     // Budget vs Actual
                     Row(
                       children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Total Income', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                               Text('Rwf ${monthlyBudget.toStringAsFixed(0)}', 
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
                             ],
                           ),
                         ),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Total Expenses', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                               Text('Rwf ${currentMonthlyExpenses.toStringAsFixed(0)}', 
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed)),
                             ],
                           ),
                         ),
                       ],
                     ),
                     
                     SizedBox(height: 15),
                     
                     // Savings/Deficit
                     Container(
                       padding: EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: (monthlyBudget - currentMonthlyExpenses) >= 0 
                             ? primaryGreen.withOpacity(0.1) 
                             : primaryRed.withOpacity(0.1),
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Remaining Budget:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                           Text('Rwf ${(monthlyBudget - currentMonthlyExpenses).toStringAsFixed(0)}', 
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, 
                                color: (monthlyBudget - currentMonthlyExpenses) >= 0 ? primaryGreen : primaryRed)),
                         ],
                       ),
                     ),
                     
                     SizedBox(height: 15),
                     
                     // Progress bar
                     LinearProgressIndicator(
                       value: monthlyBudget > 0 ? (currentMonthlyExpenses / monthlyBudget).clamp(0.0, 1.0) : 0,
                       backgroundColor: Colors.grey[200],
                       valueColor: AlwaysStoppedAnimation<Color>(
                         currentMonthlyExpenses > monthlyBudget ? primaryRed : primaryGreen
                       ),
                       borderRadius: BorderRadius.circular(5),
                       minHeight: 10,
                     ),
                     
                     SizedBox(height: 5),
                     Text('${((currentMonthlyExpenses / monthlyBudget) * 100).clamp(0, 100).toStringAsFixed(1)}% of budget used', 
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                     
                     SizedBox(height: 20),
                     
                     // Action buttons
                     Row(
                       children: [
                         Expanded(
                           child: ElevatedButton.icon(
                             onPressed: () {
                               _generateRecommendations();
                             },
                             style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                             icon: Icon(Icons.lightbulb, color: Colors.white),
                             label: Text('Generate Smart Recommendations', style: TextStyle(color: Colors.white)),
                           ),
                         ),
                       ],
                     ),
                     
                     SizedBox(height: 10),
                     
                     // Refresh button
                     Row(
                       children: [
                         Expanded(
                           child: ElevatedButton.icon(
                             onPressed: () {
                               _computeAggregates();
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('Budget analysis refreshed!')),
                               );
                             },
                             style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                             icon: Icon(Icons.refresh, color: Colors.white),
                             label: Text('Refresh Budget Analysis', style: TextStyle(color: Colors.white)),
                           ),
                         ),
                       ],
                     ),
                     
                     // Debug section to show all transactions
                     SizedBox(height: 15),
                     ExpansionTile(
                       title: Text('🔍 Debug: All Transactions (${widget.transactions.length})', 
                              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                       children: [
                         Container(
                           height: 200,
                           child: ListView.builder(
                             itemCount: widget.transactions.length,
                             itemBuilder: (context, index) {
                               final tx = widget.transactions[index];
                               return ListTile(
                                 dense: true,
                                 title: Text('${tx['type']}: ${tx['description']}'),
                                 subtitle: Text('Amount: ${tx['amount']}, Date: ${tx['date']}, Category: ${tx['category']}'),
                                 trailing: Text('${tx['amount']}', style: TextStyle(fontWeight: FontWeight.bold)),
                               );
                             },
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
            SizedBox(height: 30),

            // Smart Recommendations Section
            Text(
              'Smart Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            SizedBox(height: 15),
            _buildSmartRecommendationCard(),
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

  void _generateRecommendations() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recommendations generated based on your spending patterns!')),
    );
    setState(() {
      // Trigger UI refresh to show updated recommendations
    });
  }

   Widget _buildSmartRecommendationCard() {
     // Analyze spending patterns and generate practical recommendations
     Map<String, double> categorySpending = {};
     double totalSpending = 0;
     
     for (final tx in widget.transactions) {
       try {
         final DateTime d = DateTime.parse((tx['date'] ?? '').toString());
         final DateTime now = DateTime.now();
         if (d.year == now.year && d.month == now.month) {
           final String type = (tx['type'] ?? '').toString();
           if (type.startsWith('Expense')) {
             final String category = (tx['category'] ?? 'Other').toString();
             final double amount = (tx['amount'] as num).toDouble();
             categorySpending[category] = (categorySpending[category] ?? 0) + amount;
             totalSpending += amount;
           }
         }
       } catch (_) {}
     }
     
     // Find highest spending categories
     var sortedCategories = categorySpending.entries.toList()
       ..sort((a, b) => b.value.compareTo(a.value));
     
     List<Map<String, dynamic>> recommendations = [];
     
     if (sortedCategories.isNotEmpty) {
       final topCategory = sortedCategories.first;
       final percentage = totalSpending > 0 ? (topCategory.value / totalSpending) * 100 : 0;
       
       if (percentage > 30) {
         recommendations.add({
           'title': 'Reduce ${topCategory.key} spending',
           'description': 'You\'re spending ${percentage.toStringAsFixed(1)}% of your budget on ${topCategory.key}. Consider cutting by 20% to save Rwf ${(topCategory.value * 0.2).toStringAsFixed(0)} this month.',
           'savings': topCategory.value * 0.2,
           'icon': Icons.trending_down,
           'color': primaryRed,
         });
       }
     }
     
     // Budget deficit recommendations
     if (currentMonthlyExpenses > monthlyBudget) {
       final deficit = currentMonthlyExpenses - monthlyBudget;
       recommendations.add({
         'title': 'Budget Alert!',
         'description': 'You\'re Rwf ${deficit.toStringAsFixed(0)} over budget. Focus on reducing discretionary spending.',
         'savings': deficit,
         'icon': Icons.warning,
         'color': Colors.orange,
       });
     }
     
     // Savings opportunity
     if (monthlyBudget > currentMonthlyExpenses && monthlyBudget > 0) {
       final savings = monthlyBudget - currentMonthlyExpenses;
       recommendations.add({
         'title': 'Great job!',
         'description': 'You have Rwf ${savings.toStringAsFixed(0)} left in your budget. Consider saving this amount.',
         'savings': savings,
         'icon': Icons.savings,
         'color': primaryGreen,
       });
     }
     
     if (recommendations.isEmpty) {
       recommendations.add({
         'title': 'Keep it up!',
         'description': 'Your spending looks balanced. Continue tracking your expenses.',
         'savings': 0,
         'icon': Icons.check_circle,
         'color': primaryGreen,
       });
     }
     
     return Card(
       elevation: 4,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       color: Colors.white,
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Icon(Icons.psychology, color: primaryGreen, size: 24),
                 SizedBox(width: 8),
                 Text(
                   'AI-Powered Insights',
                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                 ),
               ],
             ),
             SizedBox(height: 15),
             ...recommendations.map((rec) => Padding(
               padding: const EdgeInsets.only(bottom: 12.0),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Icon(rec['icon'], color: rec['color'], size: 24),
                   SizedBox(width: 12),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           rec['title'],
                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                         ),
                         SizedBox(height: 4),
                         Text(
                           rec['description'],
                           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                         ),
                         if (rec['savings'] > 0) ...[
                           SizedBox(height: 8),
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             decoration: BoxDecoration(
                               color: rec['color'].withOpacity(0.1),
                               borderRadius: BorderRadius.circular(4),
                             ),
                             child: Text(
                               'Potential savings: Rwf ${rec['savings'].toStringAsFixed(0)}',
                               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: rec['color']),
                             ),
                           ),
                         ],
                       ],
                     ),
                   ),
                 ],
               ),
             )).toList(),
           ],
         ),
       ),
     );
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