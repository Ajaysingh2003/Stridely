import 'package:app/features/book/domain/entity/book_entity.dart';
import 'package:app/features/book/domain/entity/book_failure.dart';
import 'package:app/features/book/domain/repository/book_repository.dart';
import 'package:app/features/home/domain/entity/category_entity.dart';
import 'package:app/features/home/domain/entity/collection_entity.dart';
import 'package:dartz/dartz.dart';

class GetCategoryUsecase {
  final BookRepository _repository;
  const GetCategoryUsecase(this._repository);

  Future<Either<BookFailure, List<CategoryEntity>>> call() {
    return _repository.getCategory();
  }

}
