import 'package:flutter_album_app/features/albums/domain/models/album.dart';
import 'package:flutter_album_app/features/albums/domain/repositories/album_repository.dart';

class GetAlbums {
  final AlbumRepository repository;

  GetAlbums(this.repository);

  Future<List<Album>> call() async {
    return await repository.getAlbums();
  }
} 