import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      print("Sign In Success: ${user?.uid}");
      return user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      print("Registration Success: ${user?.uid}");
      return user;
    } catch (e) {
      print("Registration Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    print("Sign Out Success");
  }

  Stream<User?> get userStream => _auth.authStateChanges();
}
