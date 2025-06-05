import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/wallet_model.dart';

class WalletService {
  final String baseUrl;

  WalletService({this.baseUrl = 'https://wallet-testing-murex.vercel.app'});

  Future<List<Wallet>> getWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/wallets'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Wallet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load wallets');
    }
  }

  Future<Wallet> getWalletDetail(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/wallets/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Wallet.fromJson(data);
    } else {
      throw Exception('Failed to fetch wallet detail');
    }
  }
}
