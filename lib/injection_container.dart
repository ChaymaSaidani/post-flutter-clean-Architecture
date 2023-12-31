import 'package:post_app/features/auth/data/datasource/user_local_data_source.dart';
import 'package:post_app/features/auth/data/datasource/user_remote_data_source.dart';
import 'package:post_app/features/auth/data/repositories/user_repo_impl.dart';
import 'package:post_app/features/auth/domain/repositories/user_repo.dart';
import 'package:post_app/features/auth/domain/usecases/get_cached_user.dart';
import 'package:post_app/features/auth/domain/usecases/sign_in_user.dart';
import 'package:post_app/features/auth/domain/usecases/sign_out_user.dart';
import 'package:post_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:post_app/features/post/data/dataressource/post_local_data_source.dart';
import 'package:post_app/features/post/data/dataressource/post_remote_data_source.dart';
import 'package:post_app/features/post/data/repositories/post_repository.dart';
import 'package:post_app/features/post/domain/repositories/post_repository.dart';
import 'package:post_app/features/post/domain/usecases/add_post.dart';
import 'package:post_app/features/post/domain/usecases/delete_post.dart';
import 'package:post_app/features/post/domain/usecases/get_all_post.dart';
import 'package:post_app/features/post/domain/usecases/update_post.dart';
import 'package:post_app/features/post/presentation/bloc/add_update_delete_post/add_update_delete_post_bloc.dart';
import 'package:post_app/features/post/presentation/bloc/posts/posts_bloc.dart';

import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

// Bloc
  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(() => AddUpdateDeletePostBloc(
      addPost: sl(), updatePost: sl(), deletePost: sl()));
  sl.registerLazySingleton(() => AuthBloc(signInUserUseCase: sl(), signOutUserUseCase: sl()));


// Usecases

  sl.registerLazySingleton(() => GetAllPostsUsecase(sl()));
  sl.registerLazySingleton(() => AddPostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));
  sl.registerLazySingleton(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

// Repository

  sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      userRemoteDataSource: sl(), userLocalDataSource: sl(), networtkInfo: sl()));

// Datasources

  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(() =>
                   UserLocalDataSourceImpl(sharedPreferences: sl())
  );

//Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  
}