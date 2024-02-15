// music_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MusicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addMusic(String userId, String title, String artist, String downloadUrl) async {
    try {
      await _firestore.collection('music').add({
        'userId': userId,
        'title': title,
        'artist': artist,
        'downloadUrl': downloadUrl,
      });
    } catch (error) {
      print('Error adding music: $error');
      throw 'Failed to add music';
    }
  }

  Future<List<Map<String, dynamic>>> loadMusicData(String userId) async {
    try {
      QuerySnapshot musicSnapshot = await _firestore
          .collection('music')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> musicList = musicSnapshot.docs
          .map((DocumentSnapshot document) => document.data() as Map<String, dynamic>)
          .toList();

      return musicList;
    } catch (error) {
      print('Error loading music data: $error');
      throw 'Failed to load music data';
    }
  }

  Future<void> deleteMusic(String musicId) async {
    try {
      // Hapus data musik dari Firestore
      await _firestore.collection('music').doc(musicId).delete();

      // Hapus file musik dari Firebase Storage
      String filePath = 'music/$musicId.mp3';
      await _storage.ref(filePath).delete();
    } catch (error) {
      print('Error deleting music: $error');
      throw 'Failed to delete music';
    }
  }

  Future<String> getMusicUrl(String userId, String musicId) async {
    try {
      final downloadUrl = await _storage.ref('users/$userId/music/$musicId.mp3').getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error getting music URL: $error');
      throw 'Failed to get music URL';
    }
  }
}
