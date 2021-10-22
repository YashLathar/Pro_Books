import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// ignore: implementation_imports
import 'package:flutter_riverpod/src/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_book/controllers/book_service_controller.dart';

class BookDetailsPage extends HookWidget {
  const BookDetailsPage(
      {required this.bookImageUrl,
      required this.bookName,
      required this.category,
      required this.bookAuthor,
      required this.id,
      required this.bookDescription,
      Key? key})
      : super(key: key);

  final String bookImageUrl;
  final String bookName;
  final String category;
  final String bookAuthor;
  final String id;
  final String bookDescription;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        color: const Color(0xff181c18),
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: size.height / 2.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        bookImageUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xffc2fbe1),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            bookName,
                            style: GoogleFonts.montserrat(
                                fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            bookDescription.length > 100
                                ? bookDescription.substring(0, 100) + "..."
                                : bookDescription + " ...",
                            style: GoogleFonts.montserrat(fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "~" + bookAuthor,
                                style: GoogleFonts.montserrat(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: size.width,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 55,
                              color: Colors.deepPurple,
                              onPressed: () async {
                                await context
                                    .read(
                                        bookServiceControllerProvider.notifier)
                                    .addToFav(
                                        id: id,
                                        bookAuthor: bookAuthor,
                                        bookImageUrl: bookImageUrl,
                                        bookDescription: bookDescription,
                                        bookName: bookName,
                                        category: category,
                                        context: context);
                              },
                              child: const Text(
                                "Add to Favourites",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
