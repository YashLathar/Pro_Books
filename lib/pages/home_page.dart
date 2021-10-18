import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/book_exception.dart';
import 'package:pro_book/entities/book.dart';
import 'package:pro_book/pages/favourites_page.dart';
import 'package:pro_book/services/auth_service.dart';
import 'package:pro_book/services/book_service.dart';
import 'package:pro_book/widgets/book_component.dart';
import 'package:pro_book/widgets/error_component.dart';

final bookFutureProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  ref.maintainState = true;

  final bookService = ref.watch(bookServiceProvider);
  final query = ref.watch(queryProvider);
  final books = await bookService.getBooks(query.state);
  return books;
});

final queryProvider = StateProvider<String>((ref) {
  return "";
});

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final books = useProvider(bookFutureProvider);
    final _searchFieldController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        leading: IconButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            const Text(
                              "Log Out Confirm ?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await context
                                        .read(authServiceProvider)
                                        .signOut();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Log Out"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          },
          icon: const Icon(
            FontAwesomeIcons.signOutAlt,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouritesPage(),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.solidHeart),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Explore thousands of books on the go",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: CupertinoSearchTextField(
              controller: _searchFieldController,
              onSubmitted: (query) {
                context.read(queryProvider).state = query;
                context.refresh(bookServiceProvider);
              },
              padding: const EdgeInsets.all(15),
            ),
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
                                bookImageUrl: book.volumeInfo
                                        .containsKey("imageLinks")
                                    ? book.volumeInfo["imageLinks"]
                                        ["smallThumbnail"]
                                    : "https://books.google.co.in/googlebooks/images/no_cover_thumb.gif",
                                bookName: book.volumeInfo["title"],
                                bookAuthor:
                                    book.volumeInfo.containsKey("authors")
                                        ? book.volumeInfo["authors"][0]
                                        : "anonymous",
                                category:
                                    book.volumeInfo.containsKey("categories")
                                        ? book.volumeInfo["categories"][0]
                                        : "notGiven",
                              ))
                          .toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) {
                  if (e is BooksException) {
                    return ErrorBody(message: e.message!);
                  }
                  return const ErrorBody(
                      message: "Oops, something unexpected happened");
                }),
          ),
        ],
      ),
    );
  }
}
