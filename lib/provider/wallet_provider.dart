// lib/provider/wallet_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_test/provider/service_provider.dart';
import '../data/model/wallet_model.dart';

final walletProvider = FutureProvider<List<Wallet>>((ref) async {
  final service = ref.watch(walletServiceProvider);
  return service.getWallets();
});

final walletDetailProvider = FutureProvider.family<Wallet, int>((ref, id) async {
  final service = ref.watch(walletServiceProvider);
  return service.getWalletDetail(id);
});
