import 'package:cloud_firestore/cloud_firestore.dart';

class PaginatedResponse<T> {
  final List<T> items;                  // Your mapped domain model list (e.g., BookEntity)
  final DocumentSnapshot? lastDocument; // The cursor token for your next network page query
  final int totalCount;                 // The total count matching your query filters
  final bool hasMore;                   // Helper flag indicating if another page exists

  const PaginatedResponse({
    required this.items,
    this.lastDocument,
    required this.totalCount,
    required this.hasMore,
  });
}