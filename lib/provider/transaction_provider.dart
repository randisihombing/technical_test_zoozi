import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_test/provider/service_provider.dart';
import '../data/model/transaction_model.dart';

final transactionListProvider = FutureProvider.family<List<Transaction>, int>((ref, walletId) {
  final service = ref.watch(transactionServiceProvider);
  return service.getTransactions(walletId);
});

final transactionDetailProvider = FutureProvider.family<Transaction, (int walletId, int txId)>((ref, params) {
  final service = ref.watch(transactionServiceProvider);
  final (walletId, txId) = params;
  return service.getTransactionDetail(walletId, txId);
});