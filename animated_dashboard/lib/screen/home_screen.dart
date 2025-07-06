import 'package:animated_dashboard/dashboard/component/bouncing_button.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_desktop.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_extra_wide.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_mobile.dart';
import 'package:animated_dashboard/dashboard/layout/dashboard_layout_tablet.dart';
import 'package:animated_dashboard/dashboard/layout/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../common/animation/animation.dart';
import '../common/const/responsive.dart';
import '../dashboard/component/animated_floating_action_button.dart';
import '../dashboard/component/disappearing_bottom_navigation_bar.dart';
import '../dashboard/component/disappearing_navigation_rail.dart';
import '../dashboard/layout/dashboard_rightbar.dart';
import '../dashboard/models/models.dart';
import 'dart:math' as math;

import '../dashboard/transition/list_detail_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.currentUser, super.key});

  final User currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const kDefaultTextStyle = TextStyle(color: Colors.white);

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool useLiquidGlass = true;
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

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _detailController]),
      builder: (context, _) {
        return Stack(
          children: [
            Image.asset(
              'assets/other_background.webp', // pubspec.yaml에 등록한 이미지 경로
              fit: BoxFit.cover, // 이미지가 화면 비율과 달라도 꽉 채우도록 설정
              width: double.infinity,
              height: double.infinity,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Total Width $screenWidth / ',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                actions: [
                  enableLiquidGlassSwitch(),
                ],
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: Row(
                    children: [
                      DisappearingNavigationRail(
                        isExtended: false,
                        railAnimation: _railAnimation,
                        railFabAnimation: _railFabAnimation,
                        backgroundColor: _backgroundColor,
                        selectedIndex: _navigationIndex,
                        onDestinationSelected: (index) {
                          setState(() {
                            _navigationIndex = index;
                            _pageController.jumpToPage(index);
                          });
                        },
                      ),
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
                              one: DashboardLayoutExtraWide(),
                              two: DashboardRightBar(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: AnimatedFloatingActionButton(
                animation: _barAnimation,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              bottomNavigationBar: DisappearingBottomNavigationBar(
                barAnimation: _barAnimation,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),

              /*Positioned(
              child: SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    liquidGlassNavBar(),
                    const SizedBox(
                      width: 20,
                    ),
                    BouncingActionButton(
                      icon: Icons.add,
                      onTap: () {},
                      useLiquidGlass: useLiquidGlass,
                    ),
                  ],
                ),
              ),
            ),*/
            ),
          ],
        );
      },
    );
  }

  Widget liquidGlassNavBar() {
    if (!useLiquidGlass) {
      return navBar();
    }

    return LiquidGlass(
      // blur: 10,
      settings: const LiquidGlassSettings(
        ambientStrength: 2,
        lightAngle: 0.4 * math.pi,
        glassColor: Colors.black12,
        thickness: 30,
      ),
      shape: const LiquidRoundedSuperellipse(borderRadius: Radius.circular(50)),
      glassContainsChild: false,
      child: navBar(opacity: 0.3),
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

  Widget navBar({double opacity = 1}) {
    return Container(
      height: 60,
      width: 284,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: opacity),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          children: [
            iconItem(Icons.home),
            iconItem(Icons.access_alarm),
            iconItem(Icons.settings),
            iconItem(Icons.person),
          ],
        ),
      ),
    );
  }

  Widget iconItem(IconData icon) {
    return Container(
      width: 70,
      height: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Center(child: Icon(icon, size: 22, color: Colors.white)),
    );
  }
}
