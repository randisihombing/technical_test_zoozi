import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../component/text.dart';
import '../../provider/transaction_provider.dart';
import '../../provider/wallet_provider.dart';
import '../transaction/deposit.dart';
import '../transaction/transaction_detail.dart';
import '../transaction/withdrawal.dart';

class WalletDetailPage extends ConsumerWidget {
  final int walletId;

  const WalletDetailPage({super.key, required this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletDetailProvider(walletId));
    final txAsync = ref.watch(transactionListProvider(walletId));

    return Scaffold(
      appBar: AppBar(title: RText('lang.walletDetail')),
      body: walletAsync.when(
        data: (wallet) {
          final created = DateFormat.yMMMd().add_jm().format(wallet.createdAt);
          final updated = DateFormat.yMMMd().add_jm().format(wallet.updatedAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Wallet ID: ${wallet.id}"),
                Text("User ID: ${wallet.userId}"),
                Text(
                  "Balance: ${wallet.balance} ${wallet.currency}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Created At: $created"),
                Text("Updated At: $updated"),
                const Divider(height: 32),
                RText("lang.transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                txAsync.when(
                  data: (transactions) => transactions.isEmpty
                      ? const Text("lang.noTransactionYet")
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return Card(
                        child: ListTile(
                          title: Text("${tx.type.toUpperCase()} - \$${tx.amount}"),
                          subtitle: Text(tx.description ?? 'No description'),
                          trailing: Text(DateFormat('dd MMM, HH:mm').format(tx.createdAt)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailPage(walletId: walletId, transactionId: tx.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('Error loading transactions: $e'),
                ),
                const SizedBox(height: 80), // extra space for buttons
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "deposit",
            onPressed: () async {
              final result =
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DepositPage(walletId: walletId)),
              );

              // Kalau berhasil, invalidate detail wallet untuk update balance
              if (result == true) {
                if (context.mounted) {
                  Navigator.pop(context, true); // <- Kembali ke Home dan trigger refresh
                }
              }

            },
            label: RText('lang.deposit'),
            icon: const Icon(Icons.arrow_downward),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: "withdraw",
            onPressed: () async{
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WithdrawPage(walletId: walletId)),
              );
              if(result == true){
                if (context.mounted) {
                  Navigator.pop(context, true); // <- Kembali ke Home dan trigger refresh
                }
              }
            },
            label: RText('lang.withdraw'),
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
