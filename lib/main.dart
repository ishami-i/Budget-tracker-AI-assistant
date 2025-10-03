import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/income_expense_screen.dart';
import 'screens/model_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(BudgetAssistantApp());
}

class BudgetAssistantApp extends StatelessWidget {
  const BudgetAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget AI Assistant',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // The central source of truth for transactions
  List<Map<String, dynamic>> _allTransactions = [
    {'type': 'Income', 'description': 'Salary', 'amount': 1000000.0, 'date': '2024-03-01', 'category': 'Work'},
    {'type': 'Expense_Planned', 'description': 'Rent', 'amount': 300000.0, 'date': '2024-03-05', 'category': 'Housing'},
    {'type': 'Expense_Planned', 'description': 'Groceries', 'amount': 150000.0, 'date': '2024-03-07', 'category': 'Food'},
    {'type': 'Expense_Unplanned', 'description': 'Coffee Shop', 'amount': 5000.0, 'date': '2024-03-08', 'category': 'Dining'},
    {'type': 'Income', 'description': 'Freelance Project', 'amount': 500000.0, 'date': '2024-03-10', 'category': 'Work'},
    {'type': 'Expense_Planned', 'description': 'Internet Bill', 'amount': 30000.0, 'date': '2024-03-12', 'category': 'Utilities'},
    {'type': 'Expense_Unplanned', 'description': 'Movie Tickets', 'amount': 15000.0, 'date': '2024-03-15', 'category': 'Entertainment'},
    // Add more sample data if needed for testing history
    {'type': 'Income', 'description': 'Bonus', 'amount': 200000.0, 'date': '22024-02-20', 'category': 'Work'},
    {'type': 'Expense_Unplanned', 'description': 'New Book', 'amount': 10000.0, 'date': '2024-02-25', 'category': 'Education'},
  ];

  // Callback function to update _allTransactions
  void _updateTransactions(List<Map<String, dynamic>> newTransactions) {
    setState(() {
      _allTransactions = newTransactions;
    });
  }

  // Screens for BottomNavigationBar
  late final List<Widget> _screens; // Mark as late as it depends on _allTransactions

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      IncomeExpensesScreen(
        initialTransactions: _allTransactions,
        onTransactionsUpdated: _updateTransactions,
      ),
      ModelRecommendationsScreen(), // ModelRecommendationsScreen might need transactions too later
      HistoryScreen(allTransactions: _allTransactions), // FIX: Pass transactions here
      SettingsScreen(),
    ];
  }

  // This will rebuild the screens list when _allTransactions changes,
  // ensuring child widgets receive the updated list.
  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _screens[1] = IncomeExpensesScreen( // Update IncomeExpensesScreen
      initialTransactions: _allTransactions,
      onTransactionsUpdated: _updateTransactions,
    );
    _screens[3] = HistoryScreen(allTransactions: _allTransactions); // Update HistoryScreen
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Income/Expense'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Model'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}