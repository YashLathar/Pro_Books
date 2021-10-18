import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Book {
  final String id;
  final Map<String, dynamic> volumeInfo;

  Book({
    required this.id,
    required this.volumeInfo,
  });

  Book copyWith({
    String? id,
    Map<String, dynamic>? volumeInfo,
  }) {
    return Book(
      id: id ?? this.id,
      volumeInfo: volumeInfo ?? this.volumeInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'volumeInfo': volumeInfo,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      volumeInfo: Map<String, dynamic>.from(map['volumeInfo']),
    );
  }

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Book.fromMap(data);
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() => 'Book(id: $id, volumeInfo: $volumeInfo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        mapEquals(other.volumeInfo, volumeInfo);
  }

  @override
  int get hashCode => id.hashCode ^ volumeInfo.hashCode;
}
