import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/core/routing/go_router_refresh_stream.dart';
import 'package:somnio/core/routing/material_route_builder.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/core/routing/tab_shell.dart';
import 'package:somnio/features/auth/presentation/pages/login_page.dart';
import 'package:somnio/features/auth/presentation/pages/signup_page.dart';
import 'package:somnio/features/posts/presentation/pages/post_detail_page.dart';
import 'package:somnio/features/posts/presentation/pages/posts_page.dart';
import 'package:user_repository/user_repository.dart';

class AppRouter {
  AppRouter({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.feed,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterRefreshStream(_userRepository.status),
    redirect: (context, state) {
      final isAuthenticated =
          _userRepository.currentUser != User.empty ||
          state.uri.path == RoutePaths.login ||
          state.uri.path == RoutePaths.signup;

      // Allow unauthenticated access to login/signup
      if (state.uri.path == RoutePaths.login ||
          state.uri.path == RoutePaths.signup) {
        if (_userRepository.currentUser != User.empty) {
          return RoutePaths.feed;
        }
        return null;
      }

      // Require auth for all other routes
      if (_userRepository.currentUser == User.empty && !isAuthenticated) {
        return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => buildMaterialPage(
          child: const LoginPage(),
          name: 'login',
        ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        pageBuilder: (context, state) => buildMaterialPage(
          child: const SignupPage(),
          name: 'signup',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.feed,
                pageBuilder: (context, state) => buildMaterialPage(
                  child: const PostsPage(),
                  name: 'feed',
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return buildMaterialPage(
                        child: PostDetailPage(id: id),
                        name: 'feed-detail',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                pageBuilder: (context, state) => buildMaterialPage(
                  child: const _PlaceholderPage(title: 'Search'),
                  name: 'search',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                pageBuilder: (context, state) => buildMaterialPage(
                  child: const _PlaceholderPage(title: 'Profile'),
                  name: 'profile',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Coming soon',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
