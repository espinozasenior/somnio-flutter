// This file imports all lib files to ensure complete coverage tracking.
// ignore_for_file: unused_import

import 'package:somnio/app/app.dart';
import 'package:somnio/app/theme/app_theme.dart';
import 'package:somnio/app/theme/theme_cubit.dart';
import 'package:somnio/core/constants/app_constants.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/error/error_handler.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/core/error/failures.dart';
import 'package:somnio/core/extensions/context_extensions.dart';
import 'package:somnio/core/network/api_error_interceptor.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/core/routing/cupertino_route_builder.dart';
import 'package:somnio/core/routing/route_paths.dart';
import 'package:somnio/core/routing/tab_shell.dart';
import 'package:somnio/core/usecase/usecase.dart';
import 'package:somnio/core/widgets/error_dialog.dart';
import 'package:somnio/core/widgets/error_view.dart';
import 'package:somnio/core/widgets/loading_view.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';
import 'package:somnio/features/posts/data/repositories/post_repository_impl.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/post_detail_state.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';
import 'package:somnio/features/posts/presentation/pages/post_detail_page.dart';
import 'package:somnio/features/posts/presentation/pages/posts_page.dart';
import 'package:somnio/features/posts/presentation/widgets/post_list_tile.dart';
import 'package:somnio/features/posts/presentation/widgets/post_shimmer.dart';

void main() {}
