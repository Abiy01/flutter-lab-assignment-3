import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_album_app/features/albums/presentation/bloc/albums_bloc.dart';
import 'package:flutter_album_app/features/albums/presentation/pages/albums_page.dart';
import 'package:flutter_album_app/features/albums/presentation/pages/album_detail_page.dart';
import 'package:flutter_album_app/features/albums/data/repositories/album_repository_impl.dart';
import 'package:flutter_album_app/features/albums/domain/usecases/get_albums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final albumRepository = AlbumRepositoryImpl();
    final getAlbumsUseCase = GetAlbums(albumRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumsBloc(getAlbumsUseCase)..add(LoadAlbums()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Album App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const AlbumsPage(),
            ),
            GoRoute(
              path: '/album/:id',
              builder: (context, state) {
                final albumId = int.parse(state.pathParameters['id']!);
                return AlbumDetailPage(albumId: albumId);
              },
            ),
          ],
        ),
      ),
    );
  }
} 