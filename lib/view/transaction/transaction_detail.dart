import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../provider/transaction_provider.dart';

class TransactionDetailPage extends ConsumerWidget {
  final int walletId;
  final int transactionId;

  const TransactionDetailPage({super.key, required this.walletId, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(transactionDetailProvider((walletId, transactionId)));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Detail')),
      body: detail.when(
        data: (tx) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Type: ${tx.type}"),
              Text("Amount: \$${tx.amount}"),
              Text("Description: ${tx.description ?? '-'}"),
              Text("Reference ID: ${tx.referenceId ?? '-'}"),
              Text("Created At: ${DateFormat.yMd().add_jm().format(tx.createdAt)}"),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
