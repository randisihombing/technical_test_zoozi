import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_source/transaction_remote_datasource.dart';
import 'dio_provider.dart';

final transactionRemoteProvider = Provider<TransactionRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionRemoteDataSource(dio);
});

final sendMoneyProvider = StateNotifierProvider<SendMoneyNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(transactionRemoteProvider);
  return SendMoneyNotifier(service);
});

class SendMoneyNotifier extends StateNotifier<AsyncValue<void>> {
  final TransactionRemoteDataSource service;

  SendMoneyNotifier(this.service) : super(const AsyncValue.data(null));

  Future<void> send(String walletId, double amount) async {
    state = const AsyncValue.loading();
    try {
      await service.sendMoney(walletId, amount);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
