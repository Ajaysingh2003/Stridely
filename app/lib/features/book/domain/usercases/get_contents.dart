import 'package:app/features/book/domain/entity/book_content_entity.dart';
import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetContentUseCase {
  final BookRepository _repository;
  const GetContentUseCase(this._repository);

  Future<Either<BookFailure, BookContent>> call(String uid) {
    return _repository.getContents(uid);
  }

}
