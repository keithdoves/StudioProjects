import 'package:badges/badges.dart';
import 'package:codefactory_lvl2_flutter/common/const/colors.dart';
import 'package:codefactory_lvl2_flutter/common/layout/default_layout.dart';
import 'package:codefactory_lvl2_flutter/common/provider/go_router.dart';
import 'package:codefactory_lvl2_flutter/common/utils/pagination_utils.dart';
import 'package:codefactory_lvl2_flutter/product/component/product_card.dart';
import 'package:codefactory_lvl2_flutter/product/model/product_model.dart';
import 'package:codefactory_lvl2_flutter/rating/component/rating_card.dart';
import 'package:codefactory_lvl2_flutter/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_lvl2_flutter/restaurant/view/basket_screen.dart';
import 'package:codefactory_lvl2_flutter/user/provider/basket_provider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../rating/model/rating_model.dart';
import '../component/restaurant_card.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';
import '../provider/restaurant_rating_provider.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';
  final String id;

  RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  //controller는 상태를 갖는 객체이기 때문에
  //컴포넌트의 생명주기와 일치시키기 위해 이 위치에 선언함
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    //초반에 Detail 요청을 보내고 상태에 저장하는 책임
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  //Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
  @override
  Widget build(BuildContext context) {
    //family로 설정했기 때문에 파라미터 넘겨줌
    //저장된 상태를 갖고 오는 책임(들어갔던 매장에 또 들어가면
    //들고 있던 데이터를 먼저 제공하고, 이내 initState에서 요청한 데이터로 바뀐다.
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);
    print(basket);

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket
                .fold<int>(
                  0,
                  (previous, next) => previous + next.count,
                )
                .toString(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          badgeStyle: BadgeStyle(
            badgeColor: PRIMARY_COLOR,
          ),
          child: Icon(
            Icons.shopping_basket_outlined,
            color: Colors.green,
          ),
        ),
      ),
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      //sliver안에 일반 위젯을 넣으려면 이걸로 감싸야함.
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(5, (index) => skeleton()),
        ),
      ),
    );
  }

  Widget skeleton() {
    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('textTextTextTextTextTextTxtxtttttttttttTT3434343xtTxtText'),
          Text('textTextTdfdfdfdfxtTxtTxtxdbzdbTxtTxtTxtTdfxdddft34d3'),
          Text('textTextTdfdfdfddfdfdxtTxtTfttxtTxtTdffdx34343434tTxtTfxt'),
          Text('textTextTdfdfdfdfdfxtxtTttfvfbdbzdfbdsbf343dbTxt'),
        ],
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              //눌렀을 때 action을 정의할 수 있음.
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                    product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(
                  model: model,
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
