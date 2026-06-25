
import 'package:flutter/material.dart';
class TagsType {
  final int iconCode;
  final String tag;
  
  const TagsType({
    required this.iconCode,
    required this.tag,
  });

  factory TagsType.fromMap(Map<String, dynamic> map) {
    return TagsType(
      // Fallback to safety default asset coordinate if null
      iconCode: map['iconCode'] ?? 58406, 
      tag: map['tag'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'iconCode': iconCode,
      'tag': tag,
    };
  }


  IconData get iconData {
    return IconData(
      iconCode, 
      fontFamily: 'MaterialIcons',
    );
  }
}