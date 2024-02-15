// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mumusic/services/storage_service.dart';
import 'package:mumusic/services/music_service.dart';
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final StorageService _storageService = StorageService();
  final MusicService _musicService = MusicService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  File? _selectedFile;

  // Metode untuk memilih file musik dari penyimpanan perangkat
  Future<void> _pickMusic() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    setState(() {
      _selectedFile = File(result.files.first.path!);
    });
  }
}

  // Metode untuk mengupload file musik dan data ke Firebase
  Future<void> _uploadMusic() async {
    if (_selectedFile != null) {
      // Contoh pemanggilan metode uploadMusic dari StorageService
      String downloadURL = await _storageService.uploadMusic(_selectedFile!, 'user_id');

      // Contoh pemanggilan metode addMusic dari MusicService
      await _musicService.addMusic('user_id', _titleController.text, _artistController.text, downloadURL);
      setState(() {
        
      });
      // Kembali ke halaman home setelah upload berhasil
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Music'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickMusic,
              child: const Text('Pick Music'),
            ),
            const SizedBox(height: 16.0),
            _selectedFile != null
                ? Text('Selected Music: ${_selectedFile!.path}')
                : const Text('No Music Selected'),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _artistController,
              decoration: const InputDecoration(labelText: 'Artist'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadMusic,
              child: const Text('Upload Music'),
            ),
          ],
        ),
      ),
    );
  }
}
