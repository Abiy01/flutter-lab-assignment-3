import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_album_app/features/albums/domain/models/album.dart';
import 'package:flutter_album_app/features/albums/domain/usecases/get_albums.dart';

// Events
abstract class AlbumsEvent extends Equatable {
  const AlbumsEvent();

  @override
  List<Object> get props => [];
}

class LoadAlbums extends AlbumsEvent {}

// States
abstract class AlbumsState extends Equatable {
  const AlbumsState();

  @override
  List<Object> get props => [];
}

class AlbumsInitial extends AlbumsState {}

class AlbumsLoading extends AlbumsState {}

class AlbumsLoaded extends AlbumsState {
  final List<Album> albums;

  const AlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class AlbumsError extends AlbumsState {
  final String message;

  const AlbumsError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  final GetAlbums getAlbums;

  AlbumsBloc(this.getAlbums) : super(AlbumsInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumsState> emit) async {
    emit(AlbumsLoading());
    try {
      final albums = await getAlbums();
      emit(AlbumsLoaded(albums));
    } catch (e) {
      emit(AlbumsError(e.toString()));
    }
  }
} 