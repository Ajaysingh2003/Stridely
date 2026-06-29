import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetContentTitleUseCase {
  final BookRepository _repository;
  const GetContentTitleUseCase(this._repository);

  Future<Either<BookFailure, List<Map<String, String>>>> call(String bookId) {
    return _repository.getContentTitle(bookId);
  }

}
