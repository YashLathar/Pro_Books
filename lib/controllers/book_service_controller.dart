import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/custom_exception.dart';

import 'package:pro_book/entities/book.dart';
import 'package:pro_book/services/auth_service.dart';
import 'package:pro_book/services/book_service.dart';
import 'package:pro_book/widgets/book_component.dart';

final bookExceptionProvider = StateProvider<CustomExeption?>((_) => null);

final bookServiceControllerProvider =
    StateNotifierProvider<BookServiceController, AsyncValue<List<Book>>>((ref) {
  final userUID = ref.read(authServiceProvider).getCurrentUID();

  return BookServiceController(ref.read, userUID);
});

class BookServiceController extends StateNotifier<AsyncValue<List<Book>>> {
  final Reader _read;
  final String? userId;

  BookServiceController(
    this._read,
    this.userId,
  ) : super(const AsyncValue.loading()) {
    if (userId != null) {
      getFavBooks();
    }
  }

  Future<void> getFavBooks() async {
    try {
      final books =
          await _read(bookServiceProvider).getFavBooks(userId: userId!);

      if (mounted) {
        state = AsyncValue.data(books);
      }
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> addToFav(
      {required id,
      required bookImageUrl,
      required bookName,
      required bookDescription,
      required category,
      required bookAuthor,
      required BuildContext context}) async {
    try {
      final book = Book(
        id: id,
        bookDescription: bookDescription,
        bookAuthor: bookAuthor,
        bookImageUrl: bookImageUrl,
        bookName: bookName,
        category: category,
      );

      await _read(bookServiceProvider)
          .addToFav(userId: userId!, book: book, context: context);

      state.whenData((books) {
        if (!books.contains(book)) {
          state = AsyncValue.data(
            books..add(book),
          );
          final snackBar = SnackBar(
            backgroundColor: Colors.deepPurple,
            content: const Text("Added to Favourites"),
            duration: const Duration(milliseconds: 1200),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read(isAddedProvider).state = true;
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.deepPurple,
            content: const Text("Already in Favourites"),
            duration: const Duration(milliseconds: 1200),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read(isAddedProvider).state = false;
        }
      });
    } on CustomExeption catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> removeFromFav(
      {required String bookId, required BuildContext context}) async {
    try {
      await _read(bookServiceProvider)
          .removeFromFav(userId: userId!, bookId: bookId, context: context);

      state.whenData((books) {
        state =
            AsyncValue.data(books..removeWhere((book) => book.id == bookId));
      });
      final snackBar = SnackBar(
        backgroundColor: Colors.deepPurple,
        content: const Text("Removed from Favourites"),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
