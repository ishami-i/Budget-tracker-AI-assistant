import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationApiService {
  final String baseUrl;

  RecommendationApiService({required this.baseUrl});

  Future<int> getRecommendation({
    required double incomeX,
    required double incomeY,
    required double expenseAmount,
    required String category,
    required String priorityFlag,
    required String currency,
    required double cutoffRate,
    required double totalExpenses,
    required double expenseRatio,
    required int riskFlag,
  }) async {
    final uri = Uri.parse('$baseUrl/predict');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'income_x': incomeX,
        'income_y': incomeY,
        'expense_amount': expenseAmount,
        'category': category,
        'priority_flag': priorityFlag,
        'currency': currency,
        'cutoff_rate': cutoffRate,
        'total_expenses': totalExpenses,
        'expense_ratio': expenseRatio,
        'risk_flag': riskFlag,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final flag = data['recommend_flag'];
      if (flag is int) return flag;
      if (flag is num) return flag.toInt();
      throw Exception('Invalid response shape: recommend_flag missing');
    }
    throw Exception('API error: ${response.statusCode} ${response.body}');
  }
}


