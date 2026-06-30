import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/tags_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRemoteDatasource {
  final FirebaseFirestore _firestore;

  BookRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _firestore.collection('books');

  Future<BookContent> getContents(String uid) async {
  try {
    final snapshot = await _firestore
        .collection("book_content")
        .where("uid", isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw const BookNotFoundFailure('The requested content does not exist.');
    }

    final firstDoc = snapshot.docs.first;

    print('this is roxxie :$snapshot');
    return BookContent.fromFirestore(firstDoc);

  } catch (e, stack) {
    print('🚨 CRITICAL DATA SOURCE EXCEPTION: $e');
    print('📋 STACK: $stack');
    
    if (e is BookFailure) rethrow;
    throw const BookServerFailure();
  }
}

  Future<List<Map<String, String>>> getContentTitle(String bookId) async {
    try {
      // print('started-chiru');
      final snapshot = await _firestore
          .collection("book_content")
          .where("bookId", isEqualTo: bookId).orderBy("position")
          .get();

      final List<Map<String, String>> bookSummaries = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;

        return {
          'uid': doc.id, 
          'title': data?['title'] as String? ?? 'Untitled Book',
        };
      }).toList();

      return bookSummaries;
    } catch (e) {
      print('data error is here ${e}');
      throw const BookServerFailure('Failed to load content references.');
    }
  }

  Future<List<Map<String, String>>> getChapters(String bookId) async {
  try {
    final snapshot = await _firestore
        .collection("book_content")
        .where("bookId", isEqualTo: bookId)
        .orderBy("position")
        .get();

    final List<Map<String, String>> bookSummaries = snapshot.docs.map((doc) {
      final data = doc.data();

      // Fallback cleanly using '??' instead of forcing direct strict type casting 'as String'

      print(' leah jaye video $data');
      return {
        'uid': doc.id, 
        'title': data['title']?.toString() ?? 'Untitled Book',
        'startTimeMs':safeString( data['startTimeMs']),
      };
    }).toList();

    return bookSummaries;
  } catch (e) {
    // This will print the precise error detail (like a missing index link) to your debug panel
    print('🎯 Firestore Fetch Error Detail: $e');
    throw const BookServerFailure('Failed to load content references.');
  }
}

  Future<List<BookEntity>> getBooks() async {
    final snapshot = await _booksCollection
        .where('isDraft', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) => _mapBook(doc.id, doc.data())).toList();
  }

  Future<BookEntity?> getBookById(String bookId) async {
    final doc = await _booksCollection.doc(bookId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return _mapBook(doc.id, doc.data()!);
  }

  BookEntity _mapBook(String id, Map<String, dynamic> data) {
    return BookEntity(
      uid: data['uid'] as String? ?? id,
      title: data['title'] as String?,
      aboutBook: data['aboutBook'] as String?,
      forWhom: data['forWhom'] as String?,
      author: AuthorType.fromJson(
        Map<String, dynamic>.from(data['author'] as Map? ?? {}),
      ),
      isFree: data['isFree'] as bool? ?? false,
      duration: data['duration'] ?? 0,
      isDraft: data['isDraft'] as bool? ?? false,
      bookCover: data['bookCover'] as String? ?? '',
      language: data['language'] as String? ?? 'English',
      collections: _toStringList(data['collections']),
      category: _toStringList(data['category']),
      rating: _toDouble(data['rating']),
      whatsInside: _toStringList(data['whatsInside']),
      takeAways: _toStringList(data['takeAways']),
      quotes: _toStringList(data['quotes']),
      // chapterCount: data["chapterCount"] ?? 0,
      description: data["description"] ?? "aa",
      tags:
          (data['tags'] as List<dynamic>?)
              ?.map(
                (tagMap) => TagsType.fromMap(tagMap as Map<String, dynamic>),
              )
              .toList() ??
          const [],

      audioUrl: data["audioUrl"] ?? "",
    );
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    return const [];
  }

  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return 0;
  }
}




String safeString(dynamic value, {String fallback = '0'}) {
  if (value == null) return fallback;
  return value.toString();
}

int safeInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is double) return value.toInt();
  
  // If it's a string, safely parse it
  return int.tryParse(value.toString()) ?? fallback;
}