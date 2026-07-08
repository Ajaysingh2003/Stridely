import 'package:flutter/foundation.dart';

@immutable
class CollectionEntity {
  final String uid;
  final String title;
  final String description;
  final String coverUrl; 


  const CollectionEntity({
    required this.uid,
    required this.title,
    required this.description,
    required  this.coverUrl,
  });

  /// Factory constructor to parse data from your backend API response
  factory CollectionEntity.fromMap(Map<String, dynamic> map) {
    return CollectionEntity(
      uid: map['uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      coverUrl: map['coverUrl'] as String,
    );
  }

  /// Converts the entity back to raw JSON format for local storage caches
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'coverUrl': coverUrl,
    };
  }

  // ── 🧠 VALUE EQUALITY ──
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          title == other.title &&
          description == other.description &&
          coverUrl == other.coverUrl;

  @override
  int get hashCode =>
      uid.hashCode ^
      title.hashCode ^
      description.hashCode ^
      coverUrl.hashCode ;
}
