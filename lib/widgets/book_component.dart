import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:pro_book/controllers/book_service_controller.dart';
import 'package:pro_book/pages/book_details_page.dart';

final isAddedProvider = StateProvider<bool>((ref) {
  return false;
});

class BookComponent extends StatelessWidget {
  const BookComponent({
    Key? key,
    required this.bookImageUrl,
    required this.bookName,
    required this.bookAuthor,
    required this.category,
    required this.bookDescription,
    required this.id,
  }) : super(key: key);

  final String bookImageUrl;
  final String bookName;
  final String category;
  final String bookAuthor;
  final String id;
  final String bookDescription;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final splittedString = category.split(" ");
    final formattedString = splittedString.sublist(0, 1);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsPage(
                bookImageUrl: bookImageUrl,
                bookName: bookName,
                category: category,
                bookAuthor: bookAuthor,
                id: id,
                bookDescription: bookDescription),
          ),
        );
      },
      onLongPress: () async {
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
                          "Remove Book, confirm?",
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
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepPurple)),
                              onPressed: () async {
                                await context
                                    .read(
                                        bookServiceControllerProvider.notifier)
                                    .removeFromFav(
                                        bookId: id, context: context);
                                Navigator.pop(context);
                              },
                              child: const Text("Remove"),
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
      child: Container(
        width: size.width,
        height: 250,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          boxShadow: [
            //background color of box
            BoxShadow(
              color: Colors.grey,
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                0, 0, // Move to bottom 10 Vertically
              ),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 130,
                height: 200,
                color: Colors.white,
                child: Image.network(
                  bookImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "by " + bookAuthor,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      bookName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            color: Colors.deepPurple,
                          ),
                          child: Text(
                            formattedString[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        LikeButton(
                          onTap: (bool isLiked) async {
                            await context
                                .read(bookServiceControllerProvider.notifier)
                                .addToFav(
                                    id: id,
                                    bookAuthor: bookAuthor,
                                    bookImageUrl: bookImageUrl,
                                    bookDescription: bookDescription,
                                    bookName: bookName,
                                    category: category,
                                    context: context);

                            isLiked = context.read(isAddedProvider).state;
                            return isLiked;
                          },
                          size: 25,
                          bubblesSize: 250,
                          animationDuration: const Duration(milliseconds: 600),
                          circleColor: const CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.redAccent : Colors.black,
                              size: 25,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
