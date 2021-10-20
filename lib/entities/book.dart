import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String bookImageUrl;
  final String bookName;
  final String category;
  final String bookDescription;
  final String bookAuthor;

  Book({
    required this.id,
    required this.bookImageUrl,
    required this.bookDescription,
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
    String? bookDescription,
  }) {
    return Book(
      id: id ?? this.id,
      bookImageUrl: bookImageUrl ?? this.bookImageUrl,
      bookName: bookName ?? this.bookName,
      bookDescription: bookDescription ?? this.bookDescription,
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
      'bookDescription': bookDescription,
    };
  }

  factory Book.fromFirebase(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      bookDescription: map["bookDescription"],
      bookImageUrl: map["bookImageUrl"],
      bookName: map["bookName"],
      category: map["category"],
      bookAuthor: map["bookAuthor"],
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> volumeInfo = map['volumeInfo'];
    return Book(
      id: map['id'],
      bookImageUrl: volumeInfo.containsKey('imageLinks')
          ? volumeInfo['imageLinks']['smallThumbnail']
          : "https://books.google.co.in/googlebooks/images/no_cover_thumb.gif",
      bookName: volumeInfo['title'],
      bookDescription: volumeInfo.containsKey('description')
          ? volumeInfo["description"]
          : "no description provided",
      category: volumeInfo.containsKey("categories")
          ? volumeInfo['categories'][0]
          : "notGiven",
      bookAuthor: volumeInfo.containsKey("authors")
          ? volumeInfo['authors'][0]
          : "anonymous",
    );
  }

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book.fromFirebase(data);
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(id: $id, bookImageUrl: $bookImageUrl,bookDescription: $bookDescription , bookName: $bookName, category: $category, bookAuthor: $bookAuthor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.bookImageUrl == bookImageUrl &&
        other.bookDescription == bookDescription &&
        other.bookName == bookName &&
        other.category == category &&
        other.bookAuthor == bookAuthor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bookImageUrl.hashCode ^
        bookDescription.hashCode ^
        bookName.hashCode ^
        category.hashCode ^
        bookAuthor.hashCode;
  }
}
