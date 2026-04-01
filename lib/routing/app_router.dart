import 'package:go_router/go_router.dart';
import 'package:recipia/data/remote_datasources/auth_remote_datasource.dart';
import 'package:recipia/presentations/cubits/auth/auth_cubit.dart';
import 'package:recipia/presentations/pages/add_recipe_page.dart';
import 'package:recipia/presentations/pages/auth_page.dart';
import 'package:recipia/presentations/pages/detail_page.dart';
import 'package:recipia/presentations/pages/home_page.dart';
import 'package:recipia/presentations/pages/onboard_page.dart';
import 'package:recipia/routing/go_router_refresh_stream.dart';

class AppRoutes {
  static final authCubit = AuthCubit(AuthRemoteDatasource());

  static final onboard = '/onboard';
  static final register = '/register';
  static final home = '/';
  static final addRecipe = '/add-recipe';
  static final detailRecipe = '/detail-recipe/:id';

  static final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    initialLocation: home,
    redirect: (context, state) {
      final authState = authCubit.state;

      if (authState.status == AuthStatus.initial) return null;

      final bool isLoggedIn = authState.status == AuthStatus.authenticated;
      final bool isLogginIn = state.matchedLocation == register;

      if (!isLoggedIn && !isLogginIn) return register;
      if (isLoggedIn && isLogginIn) return home;

      return null;
    },

    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: onboard,
        name: 'onboard',
        builder: (context, state) => OnboardPage(),
      ),
      GoRoute(
        path: detailRecipe,
        name: 'detail-recipe',
        builder: (context, state) {
          final String recipeId = state.pathParameters['id']!;
          return DetailRecipePage(recipeId: recipeId);
        },
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => AuthPage(),
      ),
      GoRoute(
        path: addRecipe,
        name: 'add-recipe',
        builder: (context, state) => AddRecipePage(),
      ),
    ],
  );
}
