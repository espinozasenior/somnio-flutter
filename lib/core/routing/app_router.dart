import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/core/routing/cupertino_route_builder.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/core/routing/tab_shell.dart';
import 'package:somnio/features/posts/presentation/pages/post_detail_page.dart';
import 'package:somnio/features/posts/presentation/pages/posts_page.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.feed,
    debugLogDiagnostics: kDebugMode,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CupertinoTabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.feed,
                pageBuilder: (context, state) => buildCupertinoPage(
                  child: const PostsPage(),
                  name: 'feed',
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return buildCupertinoPage(
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
                pageBuilder: (context, state) => buildCupertinoPage(
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
                pageBuilder: (context, state) => buildCupertinoPage(
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: Center(
        child: Text(
          'Coming soon',
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
      ),
    );
  }
}
