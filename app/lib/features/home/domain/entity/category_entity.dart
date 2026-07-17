import 'package:flutter/foundation.dart';

@immutable
class CategoryEntity {
  final String uid;
  final String title;
  const CategoryEntity({
    required this.uid,
    required this.title,

  });
}
