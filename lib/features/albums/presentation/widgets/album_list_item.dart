import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_album_app/features/albums/domain/models/album.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const AlbumListItem({
    super.key,
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: album.thumbnailUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: album.thumbnailUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            : const SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.photo_album),
              ),
        title: Text(
          album.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('Album ID: ${album.id}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
} 