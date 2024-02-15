// home_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mumusic/services/music_service.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MusicService _musicService = MusicService();
  List<Map<String, dynamic>> musicList = [];

  Future<void> _deleteMusic(BuildContext context, String musicId) async {
    try {
      await _musicService.deleteMusic(musicId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Music deleted successfully'),
        ),
      );

      _refresh();
    } catch (error) {
      print('Error deleting music: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting music. Please try again.'),
        ),
      );
    }
  }

  Future<void> _downloadMusic(BuildContext context, String musicId, String musicTitle) async {
  try {
    // Dapatkan URL musik menggunakan metode getMusicUrl dari MusicService
    String musicUrl = await _musicService.getMusicUrl('user_id', musicId);

    // Mulai pengunduhan menggunakan paket Dio
    Dio dio = Dio();
    Response response = await dio.get(
      musicUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    // Simpan file musik di penyimpanan lokal
    String fileName = '$musicTitle.mp3'; // Sesuaikan nama file jika perlu
    File file = File(fileName);
    await file.writeAsBytes(response.data, flush: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Music downloaded successfully'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // Implementasikan pembukaan file jika diperlukan
            // ...
          },
        ),
      ),
    );
  } catch (error) {
    // Handle error jika diperlukan
    print('Error downloading music: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error downloading music. Please try again.'),
      ),
    );
  }
}


  Future<void> _refresh() async {
    try {
      List<Map<String, dynamic>> refreshedMusicList = await _musicService.loadMusicData('user_id');

      setState(() {
        musicList = refreshedMusicList;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Music data refreshed successfully'),
        ),
      );
    } catch (error) {
      print('Error refreshing music data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing music data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: musicList.length,
          itemBuilder: (context, index) {
            final music = musicList[index];

            return ListTile(
              title: Text(music['title']),
              subtitle: Text(music['artist']),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteMusic(context, music['id']);
                  } else if (value == 'download') {
                    _downloadMusic(context, music['id'], music['title']);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'download',
                    child: ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Download'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/upload').then((value) {
            _refresh();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
