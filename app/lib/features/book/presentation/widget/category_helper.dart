import 'package:flutter/material.dart';

class CategoryIconHelper {
  static IconData getIconForCategory(String categoryName) {
    // Convert to lowercase to make it case-insensitive
    switch (categoryName.toLowerCase()) {
      case 'fiction':
        return Icons.auto_stories;
      case 'self growth':
      case 'trending':
        return Icons.trending_up; // Trending up icon we discussed
      case 'business':
        return Icons.business_center;
      case 'technology':
        return Icons.computer;
      case 'history':
        return Icons.history_edu;
      default:
        return Icons.category;
    }
  }
}