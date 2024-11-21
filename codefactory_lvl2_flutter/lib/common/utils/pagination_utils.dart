import 'package:codefactory_lvl2_flutter/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/cupertino.dart';

import '../provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
