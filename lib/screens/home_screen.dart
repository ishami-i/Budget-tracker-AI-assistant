import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatelessWidget {
  final Color primaryGreen = Color(0xFF63A50D);
  final Color secondaryGreen = Color(0xFFECFDCC);
  final String userName = "John Doe"; // Replace with actual user name
  final String profileImageUrl = "https://example.com/profile.jpg"; // Replace with actual profile image URL or use AssetImage

  @override
  Widget build(BuildContext context) {
    // Sample data
    final double income = 500000;
    final double plannedBudget = 400000;
    final double expenses = 350000;
    final double remainingBudget = plannedBudget - expenses;
    final double overspending = expenses > plannedBudget ? expenses - plannedBudget : 0;
    final double spendingProgress = expenses / plannedBudget.clamp(1, double.infinity); // Avoid division by zero

    // Expenses by category
    final List<ExpenseCategory> expenseData = [
      ExpenseCategory('Food', 120000, Colors.orange),
      ExpenseCategory('Transport', 80000, Colors.blue),
      ExpenseCategory('Subscriptions', 50000, Colors.red),
      ExpenseCategory('Others', 100000, Colors.purple),
    ];

    // Bar chart data
    final List<BudgetData> barData = [
      BudgetData('Income', income, primaryGreen),
      BudgetData('Budget', plannedBudget, secondaryGreen),
      BudgetData('Expenses', expenses, Colors.red),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section: Greeting, Profile, Notifications
            Container(
              padding: EdgeInsets.fromLTRB(16, 48, 16, 16), // Adjust top padding for status bar
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications, color: Colors.white),
                            onPressed: () {
                              // Handle notifications tap
                            },
                          ),
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white, // Placeholder color
                            backgroundImage: NetworkImage(profileImageUrl), // Use NetworkImage or AssetImage
                            child: profileImageUrl == null || profileImageUrl.isEmpty
                                ? Icon(Icons.person, color: primaryGreen, size: 30) // Fallback icon
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Total Income vs Expenses Summary Card
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Overview',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryGreen),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Income', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                  Text('Rwf $income',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryGreen)),
                                ],
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Expenses', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                  Text('Rwf $expenses',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey[200]),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining Budget', style: TextStyle(fontSize: 16)),
                              Text('Rwf $remainingBudget',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: remainingBudget >= 0 ? primaryGreen : Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 24),

                  // Spending Gauge / Progress Bar
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Spending Progress',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: spendingProgress > 1 ? 1 : spendingProgress,
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: spendingProgress > 0.8 && spendingProgress <= 1
                                        ? Colors.orange
                                        : spendingProgress > 1
                                            ? Colors.red
                                            : primaryGreen,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Spent: Rwf $expenses', style: TextStyle(fontSize: 14)),
                              Text('Budget: Rwf $plannedBudget', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          if (overspending > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'You are over budget by Rwf $overspending!',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Mini Pie Chart for Expenses
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Expenses by Category',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 200, // Adjusted height for mini pie chart
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.wrap,
                                position: LegendPosition.bottom, // Place legend at the bottom
                              ),
                              series: <CircularSeries>[
                                PieSeries<ExpenseCategory, String>(
                                  dataSource: expenseData,
                                  xValueMapper: (ExpenseCategory data, _) =>
                                      data.category,
                                  yValueMapper: (ExpenseCategory data, _) =>
                                      data.amount,
                                  pointColorMapper: (ExpenseCategory data, _) =>
                                      data.color,
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelPosition: ChartDataLabelPosition.outside,
                                    connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve),
                                    textStyle: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Quick Recommendations from the model
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Top Savings Tips',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen)),
                          SizedBox(height: 10),
                          _buildRecommendationItem(
                              'Cut Rwf 10,000 from dining', 'You could save Rwf 120,000 yearly!'),
                          _buildRecommendationItem(
                              'Review unnecessary subscriptions', 'Potentially save Rwf 30,000 monthly.'),
                          _buildRecommendationItem(
                              'Plan groceries for the week', 'Reduce impulse buys and save up to 15%.'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // You can choose to keep the bar chart or move it to a dedicated "Charts" section if the home gets too cluttered.
                  // For now, I'll remove it to keep the home screen focused on immediate overview.
                  // If you want to put it back, just uncomment the section below.
                  /*
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('Income vs Budget vs Expenses',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 250,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(),
                              series: <CartesianSeries<BudgetData, String>>[
                                ColumnSeries<BudgetData, String>(
                                  dataSource: barData,
                                  xValueMapper: (BudgetData data, _) => data.label,
                                  yValueMapper: (BudgetData data, _) => data.value,
                                  pointColorMapper: (BudgetData data, _) => data.color,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: primaryGreen, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models (unchanged)
class ExpenseCategory {
  final String category;
  final double amount;
  final Color color;
  ExpenseCategory(this.category, this.amount, this.color);
}

class BudgetData {
  final String label;
  final double value;
  final Color color;
  BudgetData(this.label, this.value, this.color);
}