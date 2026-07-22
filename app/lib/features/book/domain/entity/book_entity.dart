import 'package:app/features/book/domain/entity/tags_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum AuthProviderType { email, google, apple }

class AuthorType {
  final String name;
  final String bio;

  const AuthorType({required this.name, required this.bio});

  factory AuthorType.fromJson(Map<String, dynamic> json) {
    return AuthorType(
      name: json['name'] ?? 'Unknown Author',
      bio: json['bio'] ?? '',
    );
  }

  @override
  String toString() => name;
}

class BookEntity extends Equatable {
  final String uid;
  final String? title;
  final String? aboutBook;
  final String? forWhom;
  final AuthorType author;
  final bool isFree;
  final bool isFeatured;
  final int duration;
  final bool isDraft;
  final String bookCover;
  final String language;
  final List<String> collections;
  final List<String> category;
  final double rating;
  final List<String> whatsInside;
  final List<String> takeAways;
  final List<String> quotes;
  final String? description;
  final List<TagsType> tags;
  // final int chapterCount;
  final String? audioUrl;
  const BookEntity({
    required this.uid,
    required this.forWhom,
    required this.tags,
    this.description,
    required this.aboutBook,
    required this.author,
    required this.bookCover,
    required this.duration,
    required this.category,
    required this.collections,
    required this.isDraft,
    required this.isFree,
    required this.language,
    required this.quotes,
    required this.rating,
    required this.takeAways,
    required this.title,
    required this.whatsInside,
    this.isFeatured=false,
    // this.chapterCount = 0,
    this.audioUrl
  });

  @override
  List<Object?> get props => [
    uid,
    forWhom,
    aboutBook,
    author,
    bookCover,
    duration,
    category,
    collections,
    isFree,
    isDraft,
    isFree,
    description,
    tags,
    isFeatured,
    // chapterCount,
    audioUrl
  ];
}
