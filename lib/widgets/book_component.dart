import 'package:flutter/material.dart';

class BookComponent extends StatelessWidget {
  const BookComponent({
    Key? key,
    required this.bookImageUrl,
    required this.bookName,
    required this.bookAuthor,
    required this.category,
  }) : super(key: key);

  final String bookImageUrl;
  final String bookName;
  final String category;
  final String bookAuthor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final splittedString = category.split(" ");
    final formattedString = splittedString.sublist(0, 1);
    return Container(
      width: size.width,
      height: 230,
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
              height: 170,
              color: Colors.white,
              child: Image.network(
                bookImageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Color(0xff181c18),
                    ),
                    child: Text(
                      formattedString[0],
                      style: const TextStyle(
                        color: Color(0xffc0f9df),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
