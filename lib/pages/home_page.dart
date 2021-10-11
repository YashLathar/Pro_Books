import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/entities/book.dart';
import 'package:pro_book/services/book_service.dart';
import 'package:pro_book/widgets/book_component.dart';

final bookFutureProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  ref.maintainState = true;

  final bookService = ref.watch(bookServiceProvider);
  final books = await bookService.getBooks();
  return books;
});

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = useProvider(bookFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Discover our best Products",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: CupertinoSearchTextField(padding: EdgeInsets.all(15)),
          ),
          Expanded(
            child: books.when(
                data: (books) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return context.refresh(bookFutureProvider);
                    },
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      children: books
                          .map((book) => BookComponent(
                                bookImageUrl: book.volumeInfo["imageLinks"]
                                    ["smallThumbnail"],
                                bookName: book.volumeInfo["title"],
                                bookAuthor: book.volumeInfo["authors"][0],
                                category: book.volumeInfo["categories"][0],
                              ))
                          .toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) {
                  return const Text("error");
                }),
          ),
        ],
      ),
    );
  }
}
