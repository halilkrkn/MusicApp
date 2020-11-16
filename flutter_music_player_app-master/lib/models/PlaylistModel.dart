
class Playlist{

  int id;
  String title;
  String duration;
  String singer;
  String songpath;
  String photopath;
  static List<Playlist> songPlaylist = [];
  Playlist(int id,String title,String duration,String singer,String songpath,String photopath){
    this.id = id;
    this.title = title;
    this.duration = duration;
    this.singer = singer;
    this.songpath = songpath;
    this.photopath = photopath;
  }

  static void addToPlaylist(Playlist p){
    songPlaylist.add(p);
  }

  static List<Playlist> getPlaylist(){
    return songPlaylist;
  }

  static void removeItem(int id){
    songPlaylist.remove(id);
  }

  static int getListLength(){
    return songPlaylist.length;
  }

  static Playlist getPlaylistItem(index){
    return songPlaylist[index];
  }


}