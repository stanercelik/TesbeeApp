import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
