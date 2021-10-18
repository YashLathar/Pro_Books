import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String bookImageUrl;
  final String bookName;
  final String category;
  final String bookAuthor;

  Book({
    required this.id,
    required this.bookImageUrl,
    required this.bookName,
    required this.category,
    required this.bookAuthor,
  });

  Book copyWith({
    String? id,
    String? bookImageUrl,
    String? bookName,
    String? category,
    String? bookAuthor,
  }) {
    return Book(
      id: id ?? this.id,
      bookImageUrl: bookImageUrl ?? this.bookImageUrl,
      bookName: bookName ?? this.bookName,
      category: category ?? this.category,
      bookAuthor: bookAuthor ?? this.bookAuthor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookImageUrl': bookImageUrl,
      'bookName': bookName,
      'category': category,
      'bookAuthor': bookAuthor,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      bookImageUrl: map['volumeInfo']['imageLinks']['smallThumbnail'],
      bookName: map['volumeInfo']['title'],
      category: map['volumeInfo']['categories'][0],
      bookAuthor: map['volumeInfo']['authors'][0],
    );
  }

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Book.fromMap(data);
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(id: $id, bookImageUrl: $bookImageUrl, bookName: $bookName, category: $category, bookAuthor: $bookAuthor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.bookImageUrl == bookImageUrl &&
        other.bookName == bookName &&
        other.category == category &&
        other.bookAuthor == bookAuthor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookImageUrl.hashCode ^
        bookName.hashCode ^
        category.hashCode ^
        bookAuthor.hashCode;
  }
}
