import 'package:go_router/go_router.dart';
import 'package:recipia/presentations/pages/detail_page.dart';
import 'package:recipia/presentations/pages/home_page.dart';
import 'package:recipia/presentations/pages/onboard_page.dart';

class AppRoutes {
  static final home = '/';
  static final onboard = '/onboard';
  static final detailRecipe = '/detail-recipe';

  static final router = GoRouter(
    initialLocation: onboard,

    routes: [
      GoRoute(path: home, builder: (context, state) => HomePage()),
      GoRoute(path: onboard, builder: (context, state) => OnboardPage()),
      GoRoute(
        path: detailRecipe,
        builder: (context, state) => DetailRecipePage(),
      ),
    ],
  );
}
