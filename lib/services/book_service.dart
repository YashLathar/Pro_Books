import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:pro_book/custom_exception.dart';
import 'package:pro_book/ententions/firestore_extention.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_book/book_exception.dart';
import 'package:pro_book/entities/book.dart';
import 'package:pro_book/environment_config.dart';
import 'package:pro_book/general_providers.dart';

final bookServiceProvider = Provider<BookService>((ref) {
  final config = ref.watch(environmentConfigProvider);

  return BookService(config, Dio(), ref.read);
});

abstract class BaseBookService {
  Future<List<Book>> getBooks(String query);
  Future<List<Book>> getFavBooks({required String userId});
  Future<void> addToFav(
      {required String userId,
      required Book book,
      required BuildContext context});
  Future<void> removeFromFav(
      {required String userId,
      required String bookId,
      required BuildContext context});
}

class BookService implements BaseBookService {
  final Reader _read;
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  const BookService(this._environmentConfig, this._dio, this._read);

  @override
  Future<List<Book>> getBooks(String query) async {
    try {
      final updatedQuery = query.isEmpty ? "xmen" : query;

      final response = await _dio.get(
          "https://www.googleapis.com/books/v1/volumes?q=$updatedQuery&printType=books&maxResults=10&key=${_environmentConfig.booksApiKey}");

      final results = List<Map<String, dynamic>>.from(response.data["items"]);

      List<Book> books = results
          .map((bookData) => Book.fromMap(bookData))
          .toList(growable: false);

      return books;
    } on DioError catch (e) {
      throw BooksException.fromDioError(e);
    }
  }

  @override
  Future<void> addToFav(
      {required String userId,
      required Book book,
      required BuildContext context}) async {
    try {
      final bookContain =
          await _read(firestoreProvider).favBookRef(userId).doc(book.id).get();

      if (bookContain.data() == null) {
        await _read(firestoreProvider)
            .favBookRef(userId)
            .doc(book.id)
            .set(book.toMap());
      }
    } on FirebaseException catch (e) {
      throw CustomExeption(message: e.message);
    }
  }

  @override
  Future<List<Book>> getFavBooks({required String userId}) async {
    try {
      final snap = await _read(firestoreProvider).favBookRef(userId).get();

      return snap.docs.map((doc) {
        return Book.fromDocument(doc);
      }).toList();
    } on FirebaseException catch (e) {
      throw CustomExeption(message: e.message);
    }
  }

  @override
  Future<void> removeFromFav(
      {required String userId,
      required String bookId,
      required BuildContext context}) async {
    try {
      await _read(firestoreProvider).favBookRef(userId).doc(bookId).delete();
    } on FirebaseException catch (e) {
      throw CustomExeption(message: e.message);
    }
  }
}
