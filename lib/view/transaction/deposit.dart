import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../component/text.dart';

class DepositPage extends StatefulWidget {
  final int walletId;
  const DepositPage({super.key, required this.walletId});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  String? description;

  Future<void> _submit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://wallet-testing-murex.vercel.app/wallets/${widget.walletId}/transactions/deposit'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        if (description?.isNotEmpty ?? false) 'description': description,
      }),
    );

    if (response.statusCode == 201) {
      print("Ini response body: ${response.body}");
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deposit: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: RText("lang.deposit")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onSaved: (val) => amount = int.parse(val ?? '0'),
                validator: (val) => (val == null || int.tryParse(val) == null || int.parse(val) <= 0)
                    ? 'Enter valid amount'
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (val) => description = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  _submit();
                }
              }, child: RText("lang.submit"))
            ],
          ),
        ),
      ),
    );
  }
}
