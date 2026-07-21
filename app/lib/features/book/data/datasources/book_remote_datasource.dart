import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/entity/books_response.dart';
import 'package:app/features/book/domain/entity/insights_entity.dart';
import 'package:app/features/book/domain/entity/tags_type.dart';
import 'package:app/features/home/domain/entity/category_entity.dart';
import 'package:app/features/home/domain/entity/collection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

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
        throw const BookNotFoundFailure(
          'The requested content does not exist.',
        );
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
          .where("bookId", isEqualTo: bookId)
          .orderBy("position")
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


        return {
          'uid': doc.id,
          'title': data['title']?.toString() ?? 'Untitled Book',
          'startTimeMs': safeString(data['startTimeMs']),
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
  
  Future<List<CollectionEntity>> getCollections() async {

    final snapshot = await _firestore.collection('collections').get();

    final collection=snapshot.docs.map((doc) => _collectionMap(doc.id, doc.data())).toList();


    return collection;

  }
  Future<List<CategoryEntity>> getCategories() async {

    final snapshot = await _firestore.collection('category').get();

    final category=snapshot.docs.map((doc) => _categoryMap(doc.id, doc.data())).toList();

    return category;

  }

  Future<PaginatedResponse<BookEntity>> getFilteredBooks({
    String? categoryId,
    String? collectionId,
    String? searchQuery,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    // Base system constraint query builder block
    Query<Map<String, dynamic>> query = _booksCollection.where('isDraft', isEqualTo: false);

    // Apply conditional filters
    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.where('category', arrayContains: categoryId);
    }
    
    if (collectionId != null && collectionId.isNotEmpty) {
      query = query.where('collections', arrayContains: collectionId);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
          .where('searchKeywords', arrayContains: searchQuery)
          // .where('title', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .orderBy('title');
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    // ── 🔢 1. FETCH TOTAL DATA COUNT (Aggregated efficiently on Firestore servers) ──
    // final countSnapshot = await query.count().get();
    // final int totalCount = countSnapshot.count ?? 0;

    // ── 🎛️ 2. APPLY PAGINATION LIMIT CURSORS ──
    Query<Map<String, dynamic>> paginatedQuery = query.limit(limit);
    if (lastDocument != null) {
      paginatedQuery = paginatedQuery.startAfterDocument(lastDocument);
    }

    print("Previous lastDoc: ${lastDocument?.id}");


    final snapshot = await paginatedQuery.get();
    
    final books = snapshot.docs.map((doc) => _mapBook(doc.id, doc.data())).toList();
    print("Returned docs:");
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    print("New lastDoc: ${snapshot.docs.isNotEmpty ? snapshot.docs.last.id : null}");    
    final bool hasMore = books.length == limit;
    print(" books data ${books}");
    return PaginatedResponse<BookEntity>(
      items: books,
      lastDocument: lastDoc,
      totalCount: 0,
      hasMore: hasMore,
    );
  }

  Future<List<BookEntity>> getBooksFromIds(List<String> bookIds) async {
  // 1. Guard against empty lists to avoid broken SQL query syntax
  if (bookIds.isEmpty) return [];


  // 3. Query the 'books' table matching document IDs

  final snapshot = await _firestore
    .collection('books')
    .where(FieldPath.documentId, whereIn: bookIds)
    .get();

  if (snapshot.docs.isEmpty) return [];

  
  return snapshot.docs.map((doc) => _mapBook(doc.id, doc.data())).toList();

}

  Future<List<BookEntity>> getInsightes() async {
    final snapshot = await _firestore.collection("books").where("isFeatured",isEqualTo: true).get();

    print(' snap from insightes $snapshot');
    return snapshot.docs.map((doc) => _mapBook(doc.id, doc.data())).toList();
  }

  Future<List<BookEntity>> getFreeBooks() async {
    final snapshot = await _firestore.collection("books").get();

    print(' snap from insightes $snapshot');
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
      isFeatured: data['isFeatured'] as bool? ?? false,
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

  CollectionEntity _collectionMap(String id, Map<String, dynamic> data) {
    return CollectionEntity(
      uid: data['uid'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      coverUrl: data['coverUrl'] as String,
      secondaryCoverUrl:data["secondaryCoverUrl"] as String?
    );
  }

  CategoryEntity _categoryMap(String id, Map<String, dynamic> data) {
    return CategoryEntity(
      uid: data['uid'] as String,
      title: data['title'] as String,
    );
  }

  InsightsEntity _mapInsight(String id, Map<String, dynamic> data) {
    return InsightsEntity(
     uid: data['uid'] as String? ?? id,
      author: data["author"] ?? "",
      

      insights: data["insights"] != null 
          ? List<String>.from(data["insights"] as List) 
          : const [],
          
      coverUrl: data["coverUrl"] as String? ?? "",
      bookId: data["bookId"] as String? ?? "",
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
