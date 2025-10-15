import 'package:flutter/cupertino.dart';

import '../provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required CursorPaginationController<dynamic> notifier,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      notifier.paginate(
        fetchMore: true,
      );
    }
  }
}
