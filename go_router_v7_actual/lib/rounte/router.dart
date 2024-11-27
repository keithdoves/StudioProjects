import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v7_actual/screen/10_transition_screen_2.dart';
import 'package:go_router_v7_actual/screen/11_error_screen.dart';
import 'package:go_router_v7_actual/screen/2_named_screen.dart';
import 'package:go_router_v7_actual/screen/3_push_screen.dart';
import 'package:go_router_v7_actual/screen/5_pop_return_screen.dart';
import 'package:go_router_v7_actual/screen/6_path_param_screen.dart';
import 'package:go_router_v7_actual/screen/7_query_parameter.dart';
import 'package:go_router_v7_actual/screen/8_nested_child_screen.dart';
import 'package:go_router_v7_actual/screen/8_nested_screen.dart';
import 'package:go_router_v7_actual/screen/9_login_screen.dart';
import 'package:go_router_v7_actual/screen/9_private_screen.dart';
import 'package:go_router_v7_actual/screen/root_screen.dart';
import '../screen/10_transition_screen_1.dart';
import '../screen/1_basic_screen.dart';
import '../screen/4_pop_base_screen.dart';
import '../screen/8-1_state_nested_child_screen.dart';
import '../screen/8-1_stateful_nested_screen.dart';

//로그인 됐는지 안됐는지
bool authState = false;

// https://blog.codefactory.ai/ -> / -> path
// https://blog.codefactory.ai/flutter -> /flutter
// / -> home
// /basic -> basic screen
// /basic/named ->
// /named
final router = GoRouter(
  //state는 GoRouterState
  redirect: (context, state) {
    //return String (path) -> 해당 라우트로 이동한다 (path)
    //return null -> 원래 이동하려던 라우트로 이동한다.
    if (state.location == '/login/private' && !authState) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return RootScreen();
      },
      routes: [
        GoRoute(
            path: 'basic',
            builder: (context, state) {
              return BasicScreen();
            }),
        GoRoute(
            path: 'named',
            name: 'named_screen',
            builder: (context, state) {
              return NamedScreen();
            }),
        GoRoute(
            path: 'push',
            builder: (context, state) {
              return PushScreen();
            }),
        GoRoute(
          path: 'pop',
          builder: (context, state) {
            return PopBaseScreen();
          },
          routes: [
            GoRoute(
              path: 'return',
              builder: (context, state) {
                // /pop/return
                return PopReturnScreen();
              },
            ),
          ],
        ),
        GoRoute(
          // /path_param/123 으로 요청이 오면
          // 123이라는 값을 id라는 변수로 입력받음.
          path: 'path_param/:id',
          builder: (context, state) {
            return PathParamScreen();
          },
          routes: [
            GoRoute(
                path: ':name',
                builder: (context, state) {
                  return PathParamScreen();
                }),
          ],
        ),
        GoRoute(
          path: 'query_param',
          builder: (context, state) {
            return QueryParameterScreen();
          },
        ),
        ShellRoute(
          //builder의 child는 rotues의 builder에서 온다.
          // ex) NestedChildScreen(routeName: '/nested/a')
          builder: (context, state, child) {
            return NestedScreen(child: child);
          },
          routes: [
            //  /nested/a
            GoRoute(
              path: 'nested/a',
              builder: (context, state) =>
                  StateNestedChildScreen(routeName: '/nested/a'),
            ),
            // /nested/b
            GoRoute(
              path: 'nested/b',
              builder: (context, state) =>
                  StateNestedChildScreen(routeName: '/nested/b'),
            ),
            // /nested/c
            GoRoute(
              path: 'nested/c',
              builder: (context, state) =>
                  StateNestedChildScreen(routeName: '/nested/c'),
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'nested/d',
                  builder: (context, state) =>
                      NestedChildScreen(routeName: '/nested/d'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'nested/e',
                  builder: (context, state) =>
                      NestedChildScreen(routeName: '/nested/e'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'nested/f',
                  builder: (context, state) =>
                      NestedChildScreen(routeName: '/nested/f'),
                ),
              ],
            ),
          ],
          builder: (context, state, child) {
            return StatefulNestedScreen(
              child: child,
            );
          },
        ),
        GoRoute(
          path: 'login',
          builder: (_, state) => LoginScreen(),
          routes: [
            GoRoute(
              path: 'private',
              builder: (_, state) => PrivateScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'login2',
          builder: (_, state) => LoginScreen(),
          routes: [
            GoRoute(
              path: 'private',
              builder: (_, state) => PrivateScreen(),
              redirect: (context, state) {
                if (!authState) {
                  return '/login2';
                }
                return null;
              },
            ),
          ],
        ),
        GoRoute(
          path: 'transition',
          builder: (_, state) => TransitionScreenOne(),
          routes: [
            GoRoute(
              path: 'detail',
              pageBuilder: (_, state) => CustomTransitionPage(
                //animation : 정방향(go)
                //secondaryAnimation : 역방향(pop)
                transitionDuration: Duration(seconds: 3),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // 1.Fade Style
                  // return FadeTransition(
                  // 2.Scale Style
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: TransitionScreenTwo(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error.toString(),
  ),
  debugLogDiagnostics: true,
 );
