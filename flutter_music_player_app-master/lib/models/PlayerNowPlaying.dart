import 'package:audioplayers/audioplayers.dart';

class NowPlayingSong {
  final String title;
  final String artist;
  final String duration;
  final String url;
  final String photo;
  final AudioPlayer audioPlayer;
  NowPlayingSong( this.title, this.artist, this.duration, this.url, this.photo, this.audioPlayer);
}