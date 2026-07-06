import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryWidget extends ConsumerStatefulWidget {
    final String categoryId;
    const CategoryWidget({super.key,required this.categoryId});



  @override
  Widget build(BuildContext contex,WidgetRef ref) {
    final s = ref.read(filterdBooksControllerProvider).books;
      return Container();
  }
}