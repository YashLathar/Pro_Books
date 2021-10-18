import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pro_book/entities/book.dart';
import 'package:pro_book/services/auth_service.dart';
import 'package:pro_book/services/book_service.dart';

final bookServiceControllerProvider = Provider<BookServiceController>((ref) {
  final userUID = ref.read(authServiceProvider).getCurrentUID();

  return BookServiceController(ref.read, userUID);
});

class BookServiceController extends StateNotifier<AsyncValue<List<Book>>> {
  final Reader _read;
  final String? userId;

  BookServiceController(
    this._read,
    this.userId,
  ) : super(const AsyncValue.loading());

  Future<void> getFavBooks(
      {bool isLoading = false, required BuildContext context}) async {
    if (isLoading) state = const AsyncValue.loading();

    try {
      final books = await _read(bookServiceProvider)
          .getFavBooks(userId: userId!, context: context);

      if (mounted) {
        state = AsyncValue.data(books);
      }
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> addToFav(
      {required String id,
      required Map<String, dynamic> volumeInfo,
      required BuildContext context}) async {
    try {
      final book = Book(id: id, volumeInfo: volumeInfo);
      await _read(bookServiceProvider)
          .addToFav(userId: userId!, book: book, context: context);

      state.whenData(
        (books) => state = AsyncValue.data(
          books..add(book),
        ),
      );
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> removeFromFav(
      {required String bookId, required BuildContext context}) async {
    try {
      await _read(bookServiceProvider)
          .removeFromFav(userId: userId!, bookId: bookId, context: context);

      state.whenData(
        (books) => state =
            AsyncValue.data(books..removeWhere((book) => book.id == bookId)),
      );
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
