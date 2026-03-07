import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/core/widgets/error_view.dart';
import 'package:somnio/core/widgets/loading_view.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';
import 'package:somnio/features/posts/presentation/widgets/post_list_tile.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ignore: discarded_futures, BlocProvider.create is synchronous by design.
      create: (_) => getIt<PostsCubit>()..loadPosts(),
      child: const PostsView(),
    );
  }
}

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          return switch (state) {
            PostsInitial() => const SizedBox.shrink(),
            PostsLoading() => const LoadingView(),
            PostsLoaded(:final posts) => ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostListTile(
                  post: post,
                  onTap: () {
                    GoRouter.of(context).go(
                      '${RoutePaths.feed}/${post.id}',
                    );
                  },
                );
              },
            ),
            PostsError(:final failure) => ErrorView(
              failure: failure,
              onRetry: () => context.read<PostsCubit>().loadPosts(),
            ),
          };
        },
      ),
    );
  }
}
