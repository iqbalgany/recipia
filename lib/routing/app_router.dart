import 'package:go_router/go_router.dart';
import 'package:recipia/data/remote_datasources/auth_remote_datasource.dart';
import 'package:recipia/presentations/cubits/auth/auth_cubit.dart';
import 'package:recipia/presentations/pages/detail_page.dart';
import 'package:recipia/presentations/pages/home_page.dart';
import 'package:recipia/presentations/pages/onboard_page.dart';
import 'package:recipia/presentations/pages/register_page.dart';
import 'package:recipia/routing/go_router_refresh_stream.dart';

class AppRoutes {
  static final authCubit = AuthCubit(AuthRemoteDatasource());

  static final home = '/';
  static final onboard = '/onboard';
  static final detailRecipe = '/detail-recipe';
  static final register = '/register';

  static final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    initialLocation: home,
    redirect: (context, state) {
      final authState = authCubit.state;
      final bool isLoggedIn = authState.status == AuthStatus.authenticated;

      if (!isLoggedIn) return register;
      if (isLoggedIn) return home;

      return null;
    },

    routes: [
      GoRoute(path: home, builder: (context, state) => HomePage()),
      GoRoute(path: onboard, builder: (context, state) => OnboardPage()),
      GoRoute(
        path: detailRecipe,
        builder: (context, state) => DetailRecipePage(),
      ),
      GoRoute(path: register, builder: (context, state) => RegisterPage()),
    ],
  );
}
