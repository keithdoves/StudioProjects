import 'package:animated_dashboard/dashboard/component/disappearing_bottom_liquid_glass_icons.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_desktop.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_extreme_wide.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_mobile.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_tablet.dart';
import 'package:animated_dashboard/dashboard/layout/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/animation/animation.dart';
import '../common/animation/draggable_widget.dart';
import '../common/const/responsive.dart';
import '../dashboard/component/disappearing_liquid_glass_navigation_rail.dart';
import '../dashboard/component/liquid_glass_stacked_appbar.dart';
import '../dashboard/layout/dashboard_rightbar.dart';
import '../dashboard/models/models.dart';

import '../dashboard/provider/scroll_controller_provider.dart';
import '../dashboard/transition/list_detail_transition.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({required this.currentUser, super.key});

  final User currentUser;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

const kDefaultTextStyle = TextStyle(color: Colors.white);

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  bool useLiquidGlass = true;
  bool isHomeSelected = false;
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
    _colorScheme.primary.withAlpha(36),
    _colorScheme.surface,
  );
  final GlobalKey _dashboardKey = GlobalKey(); // DashboardContent용 GlobalKey 추가
  Size _dashboardSize = Size.zero;

  late final _controller = AnimationController(
    vsync: this,
    // SingleTickerProviderStateMixin
    duration: const Duration(milliseconds: 1000),
    //forward() 호출 시 0→1로 값이 변하는 데 걸리는 시간 : 1초
    reverseDuration: const Duration(milliseconds: 1250),
    //reverse() 호출 시 1→0으로 값이 돌아갈 때 적용되는 시간 : 2.5초
    value: 0,
    //컨트롤러 초기값 : 0
  );

  late final PageController _pageController;

  late final _detailController = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    vsync: this,
  );

  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);
  late final _detailAnimation = SizeAnimation(parent: _detailController);

  int _navigationIndex = 0;

  int selectedIndex = 0;
  bool isExtended = false;

  bool controllerInitialized = false;
  bool detailControllerInitialized = false;

  void _getDashboardSize() {
    // GlobalKey를 이용해 RenderBox를 찾습니다.
    final renderBox =
        _dashboardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // setState를 통해 화면을 다시 그려 크기 정보를 출력합니다.
      setState(() {
        _dashboardSize = renderBox.size;
        print(
          'DashboardContent 크기: ${_dashboardSize.width} x ${_dashboardSize.height}',
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Detail Controller 초기화 (1200px 기준)

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDashboardSize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.sizeOf(context).width;
    final bool newIsExtended = width >= DESKTOP_WIDE_MIN_WIDTH;
    if (newIsExtended != isExtended) {
      setState(() {
        isExtended = newIsExtended;
      });
    }

    //wideScreen = width > 600;

    final AnimationStatus status = _controller.status;
    //forward = 재생(+), completed : 완료(1)
    //reverse : 역재생(-), dismissed : 멈춤(0)

    if (width > TABLET_MIN_WIDTH) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        //이미 forward 중이거나 완료이면 중복 forward 요청 하지 않기 위해
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        //이미 reverse 중이거나 멈춤이면 중복 reverse 요청 하지 않기 위해
        _controller.reverse(); //다시 offset -1로
      }
    }

    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > TABLET_MIN_WIDTH ? 1 : 0;
      //위젯이 처음 만들어질 때
      //forward()나 reverse 없이도 컨트롤러 값을 세팅하여
      //현재 너비에 맞는 상태에서 곧바로 랜더링됨
    }

    final AnimationStatus detailStatus = _detailController.status;
    if (width >= DESKTOP_EXTRA_WIDE_MIN_WIDTH) {
      if (detailStatus != AnimationStatus.forward &&
          detailStatus != AnimationStatus.completed) {
        _detailController.forward();
      }
    } else {
      if (detailStatus != AnimationStatus.reverse &&
          detailStatus != AnimationStatus.dismissed) {
        _detailController.reverse();
      }
    }
    if (!detailControllerInitialized) {
      detailControllerInitialized = true;
      _detailController.value = width >= DESKTOP_EXTRA_WIDE_MIN_WIDTH ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double tabSpacing = ref.watch(mobileScrollNotifierProvider);

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _detailController]),
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Image.asset(
                  'assets/other_background.webp',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1600),
                    child: Stack(
                      // Row를 Stack으로 변경
                      children: [
                        // 1. 아래층 (배치 담당): 눈에 보이지 않지만 자리를 차지함
                        Row(
                          children: [
                            // DraggableWidget의 자식인 Rail 위젯을 투명하게 만들어 자리만 차지하게 함
                            // ✨ 크기를 정확히 맞추기 위해 실제 위젯과 동일한 내용으로 구성
                            Visibility(
                              visible: false, // 위젯을 보이지 않게 함
                              maintainState: true, // 상태는 유지
                              maintainAnimation: true, // 애니메이션도 유지
                              maintainSize: true, // ✨ 레이아웃 공간은 차지하고, 그리기(paint)는 건너뜀
                              child: DisappearingLiquidGlassNavigationRail(
                                isExtended: isExtended,
                                railAnimation: _railAnimation,
                                railFabAnimation: _railFabAnimation,
                                backgroundColor: _backgroundColor,
                                selectedIndex: _navigationIndex,
                              ),
                            ),
                            // ResponsiveLayout은 투명 위젯 때문에 옆으로 밀려나 제자리를 잡음
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: ResponsiveLayout(
                                  mobileBody: DashboardLayoutMobile(),
                                  tabletBody: DashboardLayoutTablet(),
                                  desktopBody: DashboardLayoutDesktop(),
                                  desktopWideBody: DashboardLayoutDesktop(),
                                  desktopExtraWideBody: ListDetailTransition(
                                    animation: _detailAnimation,
                                    one: DashboardLayoutExtremeWideDesktop(),
                                    two: DashboardRightBar(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 2. 위층 (실제 보이는 위젯): 아래층 레이아웃 위에 그려짐
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DraggableWidget(
                              child: DisappearingLiquidGlassNavigationRail(
                                isExtended: isExtended,
                                railAnimation: _railAnimation,
                                railFabAnimation: _railFabAnimation,
                                backgroundColor: _backgroundColor,
                                selectedIndex: _navigationIndex,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF032343).withAlpha(0),
                          const Color(0xFF032343),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1600),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Column(
                          children: [
                            LiquidGlassStackedAppbar(screenWidth: screenWidth),
                            const Spacer(),
                            DisappearingBottomLiquidGlassIcons(
                              tabSpacing: tabSpacing,
                              onPressed: () {
                                setState(() {
                                  isHomeSelected = !isHomeSelected;
                                  print('isHomeSelected: $isHomeSelected');
                                });
                              },
                              isHomeSelected: isHomeSelected,
                              barAnimation: _barAnimation,
                              selectedIndex: selectedIndex,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget enableLiquidGlassSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Enable liquid glass", style: kDefaultTextStyle),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Switch(
              activeColor: Colors.white.withAlpha(30),
              value: useLiquidGlass,
              onChanged: (value) {
                setState(() => useLiquidGlass = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
