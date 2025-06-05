import 'package:dio/dio.dart';

class TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSource(this.dio);

  Future<void> sendMoney(String toWalletId, double amount) async {
    await dio.post('/transactions/send', data: {
      'to_wallet_id': toWalletId,
      'amount': amount,
    });
  }
}
