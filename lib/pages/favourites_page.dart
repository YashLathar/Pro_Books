import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/controllers/book_service_controller.dart';
import 'package:pro_book/custom_exception.dart';
import 'package:pro_book/widgets/book_component.dart';

class FavouritesPage extends HookConsumerWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(bookServiceControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Favourites"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SafeArea(
        child: data.when(
            data: (books) {
              return books.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(child: Image.asset("assets/mt.gif")),
                        const Text(
                          "Add books to fav",
                          style: TextStyle(fontSize: 35),
                        ),
                      ],
                    ))
                  : RefreshIndicator(
                      onRefresh: () {
                        return ref
                            .refresh(bookServiceControllerProvider.notifier)
                            .getFavBooks();
                      },
                      child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          final book = books[index];
                          return BookComponent(
                            bookImageUrl: book.bookImageUrl,
                            bookDescription: book.bookDescription,
                            bookName: book.bookName,
                            bookAuthor: book.bookAuthor,
                            category: book.category,
                            id: book.id,
                          );
                        },
                      ),
                    );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
                  child: Text(error is CustomExeption
                      ? error.message!
                      : "Something Went wrong, swipe from top to Refresh"),
                )),
      ),
    );
  }
}
