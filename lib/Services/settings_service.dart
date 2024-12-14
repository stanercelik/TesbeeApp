import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserSettings({
    required String beadColor,
    required String stringColor,
    required bool isVibration,
    required bool isSoundEffect,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('settingsId')
            .set({
          'beadColor': beadColor,
          'stringColor': stringColor,
          'isVibration': isVibration,
          'isSoundEffect': isSoundEffect,
        });
      } catch (e) {
        print("Error saving settings: $e");
      }
    }
  }

  Future<Map<String, dynamic>?> getUserSettings() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('settingsId')
            .get();
        return doc.data() as Map<String, dynamic>?;
      } catch (e) {
        print("Error fetching settings: $e");
        return null;
      }
    }
    return null;
  }
}
