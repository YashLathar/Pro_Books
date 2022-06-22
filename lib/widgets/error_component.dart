import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pro_book/services/book_service.dart';

class ErrorBody extends ConsumerWidget {
  const ErrorBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 25),
          ),
          ElevatedButton(
            onPressed: () => ref.refresh(bookServiceProvider),
            child: const Text("Try again"),
          ),
        ],
      ),
    );
  }
}
