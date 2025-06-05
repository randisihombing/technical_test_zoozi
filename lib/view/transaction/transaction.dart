import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:technical_test/view/transaction/transaction_detail.dart';
import 'package:technical_test/view/transaction/withdrawal.dart';

import '../../component/text.dart';
import '../../provider/transaction_provider.dart';
import 'deposit.dart';

class TransactionListPage extends ConsumerWidget {
  final int walletId;

  const TransactionListPage({super.key, required this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionList = ref.watch(transactionListProvider(walletId));

    return Scaffold(
      appBar: AppBar(title: RText('lang.transactions')),
      body: transactionList.when(
        data: (transactions) => ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              title: Text('${tx.type.toUpperCase()} - \$${tx.amount}'),
              subtitle: Text(tx.description ?? 'No description'),
              trailing: Text(
                DateFormat('dd MMM, HH:mm').format(tx.createdAt),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => TransactionDetailPage(walletId: walletId, transactionId: tx.id),
                ));
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "deposit",
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => DepositPage(walletId: walletId),
            )),
            label: RText('lang.deposit'),
            icon: const Icon(Icons.arrow_downward),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: "withdraw",
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => WithdrawPage(walletId: walletId),
            )),
            label: RText('lang.withdraw'),
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
