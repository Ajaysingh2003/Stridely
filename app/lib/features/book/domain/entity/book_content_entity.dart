import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BookContent extends Equatable {
  final String uid;
  final String title;
  final String content;
  final String bookId;
  final int position;
  final int? startTimeMs;

  const BookContent({
    required this.uid,
    required this.bookId,
    required this.title,
    required this.position,
    required this.content,
    required this.startTimeMs,
  });

  factory BookContent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return BookContent(
      uid: doc.id,
      title: data?['title'] as String? ?? 'Untitled Book',
      bookId: doc?["bookId"] as String,
      content: data?['content'] as String? ?? '',
      position: data?["position"] ?? 0,
      startTimeMs:data?["startTimeMs"] ?? ""
    );
  }

  // 💾 Formats values cleanly when saving back up to your Firebase console collections
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [uid, title, content,bookId,position];
}