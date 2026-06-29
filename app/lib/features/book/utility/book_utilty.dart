import 'package:app/features/book/domain/entity/book_entity.dart';

extension BookAccessGuard on BookEntity {
  bool canAccessAudio(bool isUserPremium) {
    
    if (isFree) return true;
    
    return isUserPremium;
  }
}