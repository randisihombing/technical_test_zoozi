import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_test/view/wallet/add_wallet.dart';
import 'package:technical_test/view/wallet/wallet_detail.dart';

import '../auth/auth_notifier.dart';
import '../component/text.dart';
import '../provider/transaction_provider.dart';
import '../provider/wallet_provider.dart';
import 'login.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: RText('lang.myWallets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();

              // Navigasi ke halaman login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: walletState.when(
        data: (wallets) {
          return ListView.builder(
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return GestureDetector(
                onTap: ()async{
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WalletDetailPage(walletId: wallet.id),
                    ),
                  );

                  if (result == true) {
                    // Refresh detail dan list wallet
                    ref.invalidate(walletDetailProvider(wallet.id));
                    ref.invalidate(walletProvider);
                    ref.invalidate(transactionListProvider(wallet.id));
                  }
                },
                child: ListTile(
                  title: Text(wallet.id.toString()),
                  subtitle: Text('ID: ${wallet.userId.toString()}'),
                  trailing: Text(
                    '${wallet.currency} ${wallet.balance.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWalletPage()),
          );
          if (result == true) {
            ref.invalidate(walletProvider); // Refresh data
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
