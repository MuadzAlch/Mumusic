// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class MusicService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<void> addMusic(String userId, String title, String artist, String url) async {
    try {
      await firestore.collection('music').add({
        'userId': userId,
        'title': title,
        'artist': artist,
        'url': url,
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getMusicList(String userId) async {
    try {
      QuerySnapshot snapshot = await firestore.collection('music').where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  
  Future<void> deleteMusic(String userId) async {
    try {
      // Hapus data musik dari Firestore
      await firestore.collection('music').doc(userId).delete();

      // Dapatkan URL dari Firestore untuk file musik di Firebase Storage
      DocumentSnapshot musicDoc = await firestore.collection('music').doc(userId).get();
      String storageUrl = musicDoc['storageUrl'];

      // Hapus file musik dari Firebase Storage
      await _storage.refFromURL(storageUrl).delete();
    } catch (error) {
      print('Error deleting music: $error');
      // Handle error jika diperlukan
      throw error;
    }
  }

  getMusicUrl(String userId) {}
}

