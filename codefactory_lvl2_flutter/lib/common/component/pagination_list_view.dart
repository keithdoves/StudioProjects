import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//ListView의 Builder 파라미터처럼
//위젯을 넣으면 UI로 빌드되는 파라미터를 만듬
typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(listener);
    super.initState();
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        widget.provider.notifier,
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    //타입 비교 할 때 is 사용
    // 완전 처음 로딩일 때
    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } // End of Loading

    //에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: Text(
              '다시시도',
            ),
          ),
        ],
      );
    } //End of Error

    //data를 CursorPagination 타입으로 캐스팅
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: ListView.separated(
        controller: controller, //ListView 속성을 갖고 올 수 있음
        itemCount: cp.data.length + 1, //한 개의 추가 위젯을 그리겠다는 의미
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터입니다아....'),
              ),
            );
          }
          final pItem = cp.data[index];
          // final pItem = RestaurantModel.fromJson(
          //   item,
          //);

          /*final pItem = RestaurantModel(
              // 이렇게 받아서 모델에 넣는 것을 모델에 구현함.
                  id: item['id'],
                  name: item['name'],
                  thumbUrl: 'http://$ip${item['thumbUrl']}',
                  tags: List.from(item['tags']),
                  priceRange: RestaurantPriceRange.values
                      .firstWhere((e) => e.name == item['priceRange']),
                  ratings: item['ratings'],
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['deliveryTime'],
                  deliveryFee: item['deliveryFee']);*/

          return widget.itemBuilder(
            context,
            index,
            pItem,
          );
        },
      ),
    );
  }
}
