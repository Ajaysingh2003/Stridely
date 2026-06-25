import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/tags_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRemoteDatasource {
  final FirebaseFirestore _firestore;

  BookRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _firestore.collection('books');

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
      chapterCount: data["chapterCount"] ?? 0,
      description: data["description"] ?? "aa",
      tags: (data['tags'] as List<dynamic>?)
            ?.map((tagMap) => TagsType.fromMap(tagMap as Map<String, dynamic>))
            .toList() ?? const [],
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
