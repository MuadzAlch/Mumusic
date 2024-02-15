import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

    Future<String> uploadMusic(File file, String userId) async {
    try {
      String fileName = 'music_$userId${DateTime.now().millisecondsSinceEpoch}.mp3';
      final Reference storageReference = _storage.ref().child('music/$fileName');
      final UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() => null);
      return storageReference.getDownloadURL();
    } catch (error) {
      print('Error uploading music: $error');
      // Handle error jika diperlukan
      return '';
    }
  }

}
