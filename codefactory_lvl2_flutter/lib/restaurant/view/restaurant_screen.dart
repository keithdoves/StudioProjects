import 'package:codefactory_lvl2_flutter/common/component/pagination_list_view.dart';
import 'package:codefactory_lvl2_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  id: model.id,
                ),
              ),
            );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
