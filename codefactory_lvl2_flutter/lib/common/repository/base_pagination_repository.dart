import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:codefactory_lvl2_flutter/common/model/pagination_params.dart';
import '../model/cursor_pagination_model.dart';

//인터페이스 만들기
abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
