// music_list.dart

import 'package:flutter/material.dart';
import 'package:mumusic/services/music_service.dart';

class MusicList extends StatefulWidget {
  final List<Map<String, dynamic>> musicList;

  MusicList(this.musicList);

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final MusicService musicService = MusicService();

  Future<void> _deleteMusic(String musicId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Musik'),
        content: Text('Apakah Anda yakin ingin menghapus musik ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _confirmDelete(musicId);
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(String musicId) async {
    try {
      await musicService.deleteMusic(musicId);

      setState(() {
        widget.musicList.removeWhere((music) => music['id'] == musicId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Music deleted successfully'),
        ),
      );
    } catch (error) {
      print('Error deleting music: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting music. Please try again.'),
        ),
      );
    }
  }

  Future<void> _downloadMusic(String musicId) async {
    try {
      // Implementasikan logika untuk mengunduh musik di sini
      // ...
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music List'),
      ),
      body: ListView.builder(
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          final music = widget.musicList[index];

          return ListTile(
            title: Text(music['title']),
            subtitle: Text(music['artist']),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteMusic(music['id']);
                } else if (value == 'download') {
                  _downloadMusic(music['id']);
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
    );
  }
}
