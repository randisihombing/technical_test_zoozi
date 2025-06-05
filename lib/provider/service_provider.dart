// lib/provider/wallet_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_test/service/transaction_service.dart';
import '../service/wallet_service.dart';

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService(); // bisa disesuaikan untuk testing atau env config
});

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(); // bisa disesuaikan untuk testing atau env config
});
