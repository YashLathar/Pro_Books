import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/entities/book.dart';
import 'package:pro_book/environment_config.dart';

final bookServiceProvider = Provider<BookService>((ref) {
  final config = ref.watch(environmentConfigProvider);

  return BookService(config, Dio());
});

class BookService {
  BookService(this._environmentConfig, this._dio);

  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Book>> getBooks() async {
    final response = await _dio.get(
        "https://www.googleapis.com/books/v1/volumes?q=subject=Physics&printType=books&maxResults=5&key=${_environmentConfig.booksApiKey}");

    final results = List<Map<String, dynamic>>.from(response.data["items"]);

    List<Book> books = results
        .map((bookData) => Book.fromMap(bookData))
        .toList(growable: false);

    return books;
  }
}
