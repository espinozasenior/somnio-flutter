import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/widgets/error_view.dart';
import 'package:somnio/core/widgets/loading_view.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ignore: discarded_futures, BlocProvider.create is synchronous by design.
      create: (_) => getIt<PostDetailCubit>()..loadPost(int.parse(id)),
      child: _PostDetailView(id: id),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  const _PostDetailView({required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Post Detail'),
      ),
      child: SafeArea(
        child: BlocBuilder<PostDetailCubit, PostDetailState>(
          builder: (context, state) {
            return switch (state) {
              PostDetailInitial() => const SizedBox.shrink(),
              PostDetailLoading() => const CupertinoLoadingView(),
              PostDetailLoaded(:final post) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .navLargeTitleTextStyle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post.body,
                        style:
                            CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ],
                  ),
                ),
              PostDetailError(:final failure) => CupertinoErrorView(
                  failure: failure,
                  onRetry: () async {
                    final parsedId = int.tryParse(id);
                    if (parsedId != null) {
                      await context.read<PostDetailCubit>().loadPost(parsedId);
                    }
                  },
                ),
            };
          },
        ),
      ),
    );
  }
}
