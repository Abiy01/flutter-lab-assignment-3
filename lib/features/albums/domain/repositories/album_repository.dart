import 'package:flutter_album_app/features/albums/domain/models/album.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbums();
  Future<Album> getAlbumById(int id);
} 