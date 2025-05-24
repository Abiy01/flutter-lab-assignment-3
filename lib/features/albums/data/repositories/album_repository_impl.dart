import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_album_app/features/albums/domain/models/album.dart';
import 'package:flutter_album_app/features/albums/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final http.Client client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // List of real album names
  final List<String> _albumNames = [
    'Family Memories',
    'Vacation 2024',
    'Work Projects',
    'Nature Photography',
    'City Life',
    'Food Adventures',
    'Travel Diary',
    'Friends & Fun',
    'Special Events',
    'Daily Life',
    'Holiday Celebrations',
    'Pets & Animals',
    'Art & Creativity',
    'Sports Moments',
    'Music Concerts',
    'Wedding Album',
    'Graduation Day',
    'Birthday Parties',
    'Home & Garden',
    'Fashion & Style',
    'Sunset Views',
    'Mountain Adventures',
    'Beach Days',
    'Winter Wonderland',
    'Spring Blooms',
    'Summer Vibes',
    'Autumn Colors',
    'Night Photography',
    'Architecture',
    'Street Photography',
    'Portrait Collection',
    'Landscape Views',
    'Wildlife Photos',
    'Underwater World',
    'Aerial Shots',
    'Macro Photography',
    'Black & White',
    'Vintage Moments',
    'Modern Life',
    'Cultural Events',
    'Festival Memories',
    'Food Photography',
    'Travel Destinations',
    'Urban Exploration',
    'Rural Life',
    'Seasons Change',
    'Weather Moments',
    'Historical Places',
    'Modern Architecture',
    'Natural Wonders',
  ];

  AlbumRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<Album>> getAlbums() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/albums'));
      if (response.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(response.body);
        final List<Album> albums = albumsJson.map((json) {
          // Replace the title with a real album name
          final index = json['id'] as int;
          final realTitle = _albumNames[index % _albumNames.length];
          return Album.fromJson({
            ...json,
            'title': realTitle,
          });
        }).toList();
        
        // Fetch photos for each album
        final photosResponse = await client.get(Uri.parse('$baseUrl/photos'));
        if (photosResponse.statusCode == 200) {
          final List<dynamic> photosJson = json.decode(photosResponse.body);
          final Map<int, Map<String, dynamic>> photosMap = {};
          
          for (var photo in photosJson) {
            final albumId = photo['albumId'] as int;
            if (!photosMap.containsKey(albumId)) {
              photosMap[albumId] = photo;
            }
          }
          
          // Update albums with photo information
          return albums.map((album) {
            if (photosMap.containsKey(album.id)) {
              final photo = photosMap[album.id]!;
              return Album(
                id: album.id,
                userId: album.userId,
                title: album.title,
                thumbnailUrl: photo['thumbnailUrl'] as String,
                url: photo['url'] as String,
              );
            }
            return album;
          }).toList();
        }
        return albums;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      throw Exception('Failed to load albums: $e');
    }
  }

  @override
  Future<Album> getAlbumById(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/albums/$id'));
      if (response.statusCode == 200) {
        final albumJson = json.decode(response.body);
        // Replace the title with a real album name
        final realTitle = _albumNames[id % _albumNames.length];
        final album = Album.fromJson({
          ...albumJson,
          'title': realTitle,
        });
        
        // Fetch photo for the album
        final photosResponse = await client.get(Uri.parse('$baseUrl/photos?albumId=$id'));
        if (photosResponse.statusCode == 200) {
          final List<dynamic> photosJson = json.decode(photosResponse.body);
          if (photosJson.isNotEmpty) {
            final photo = photosJson.first;
            return Album(
              id: album.id,
              userId: album.userId,
              title: album.title,
              thumbnailUrl: photo['thumbnailUrl'] as String,
              url: photo['url'] as String,
            );
          }
        }
        return album;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      throw Exception('Failed to load album: $e');
    }
  }
} 