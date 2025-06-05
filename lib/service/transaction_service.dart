import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/transaction_model.dart';

class TransactionService {
  Future<List<Transaction>> getTransactions(int walletId, {int page = 1, int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final idWallet = walletId.toString();

    final uri = Uri.parse('https://wallet-testing-murex.vercel.app/wallets/$idWallet/transactions')
        .replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> transactionsJson = json['transactions'];
      return transactionsJson.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Transaction> getTransactionDetail(int walletId, int txId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('https://wallet-testing-murex.vercel.app/wallets/$walletId/transactions/$txId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load transaction detail');
    }
  }
}
