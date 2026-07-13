import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InsightsEntity extends Equatable {
  final String uid;
  final String author;
  final String ? coverUrl;
  final String bookId;
  final List<String> insights;

  const InsightsEntity({
    required this.uid,
    required this.author,
    required this.insights,
     this.coverUrl,
    required this.bookId
  });

  // factory BookContent.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>?;

  //   return BookContent(
  //     uid: doc.id,
  //     title: data?['title'] as String? ?? 'Untitled Book',
  //     bookId: doc?["bookId"] as String,
  //     content: data?['content'] as String? ?? '',
  //     position: data?["position"] ?? 0,
  //     startTimeMs:data?["startTimeMs"] ?? ""
  //   );
  // }

  // 💾 Formats values cleanly when saving back up to your Firebase console collections
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     'title': title,
  //     'content': content,
  //   };
  // }

  @override
  List<Object?> get props => [uid, author, insights,bookId,coverUrl];
}