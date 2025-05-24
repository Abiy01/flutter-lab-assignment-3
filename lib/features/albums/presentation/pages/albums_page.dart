import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_album_app/features/albums/presentation/bloc/albums_bloc.dart';
import 'package:flutter_album_app/features/albums/presentation/widgets/album_list_item.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: BlocBuilder<AlbumsBloc, AlbumsState>(
        builder: (context, state) {
          if (state is AlbumsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AlbumsBloc>().add(LoadAlbums());
              },
              child: ListView.builder(
                itemCount: state.albums.length,
                itemBuilder: (context, index) {
                  final album = state.albums[index];
                  return AlbumListItem(
                    album: album,
                    onTap: () => context.go('/album/${album.id}'),
                  );
                },
              ),
            );
          } else if (state is AlbumsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlbumsBloc>().add(LoadAlbums());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 