import 'package:codefactory_lvl2_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_lvl2_flutter/common/model/model_with_id.dart';
import 'package:codefactory_lvl2_flutter/common/provider/pagination_provider.dart';
import 'package:codefactory_lvl2_flutter/common/repository/base_pagination_repository.dart';
import 'package:codefactory_lvl2_flutter/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<
        T extends IModelWithId,
        R extends IBasePaginationRepository<T>,
        N extends CursorPaginationNotifier<T, R>>
    extends ConsumerStatefulWidget {
  final AutoDisposeNotifierProvider<N, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView<T, R, N>> createState() => _PaginationListViewState<T, R, N>();
}

class _PaginationListViewState<
        T extends IModelWithId,
        R extends IBasePaginationRepository<T>,
        N extends CursorPaginationNotifier<T, R>>
    extends ConsumerState<PaginationListView<T, R, N>> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      notifier: ref.read(widget.provider.notifier),
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

    // 완전 처음 로딩일때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
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
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //RefreshIndicator로 감싸면 위로 당겨 새로고침이 가능하다.
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(
            forceRefetch: true,
          );
        },
        child: ListView.separated(
          //리스트가 화면 높이를 초과하지 않아도 스크롤 할 수 있도록 해준다.
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: cp is CursorPaginationFetchingMore ? CircularProgressIndicator() : Text('마지막 데이터입니다 ㅠㅠ'),
                ),
              );
            }

            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              index,
              pItem,
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 16.0);
          },
        ),
      ),
    );
  }
}