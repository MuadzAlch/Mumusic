// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mumusic/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Contoh pemanggilan metode register dari AuthService
                  User? userCredential = await _auth.register(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  // Navigasi ke halaman home setelah registrasi berhasil
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (error) {
                  // Tampilkan pesan kesalahan
                  print(error.toString());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Registrasi gagal. Coba lagi.'),
                  ));
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
