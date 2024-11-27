import 'package:codefactory_lvl2_flutter/common/component/pagination_list_view.dart';
import 'package:codefactory_lvl2_flutter/product/component/product_card.dart';
import 'package:codefactory_lvl2_flutter/product/model/product_model.dart';
import 'package:codefactory_lvl2_flutter/product/provider/product_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              Navigator
                  .of(context)
                  .push(
                  MaterialPageRoute(
                    builder: (_) =>
                        RestaurantDetailScreen(
                          id: model.restaurant.id,
                        ),
                  ),
              );
              },
            child: ProductCard.fromProductModel(
              model: model,
            ),
          );
        });
  }
}
