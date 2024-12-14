import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbee/Constants/string_constants.dart';
import 'package:tesbee/Models/dhikr_model.dart';
import 'package:tesbee/Resources/picker_colors.dart';

class DhikrsViewModel extends GetxController {
  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  var dhikrs = <Dhikr>[].obs;
  var title = ''.obs;
  var totalCount = ''.obs;
  var pray = ''.obs;

  var titleError = ''.obs;
  var totalCountError = ''.obs;
  var prayError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDhikrsFromFirestore();
  }

  Future<void> addDhikr(Dhikr dhikr) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .doc();

      dhikr.id = docRef.id;
      await docRef.set(dhikr.toMap());
      dhikrs.add(dhikr);
    }
  }

  Future<void> deleteDhikr(Dhikr dhikr) async {
    dhikrs.remove(dhikr);
    await _deleteDhikrFromFirestore(dhikr);
  }

  Future<void> updateDhikr(Dhikr updatedDhikr) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null && updatedDhikr.id.isNotEmpty) {
      // ID kontrolü eklendi.
      updatedDhikr.timestamp = Timestamp.now();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .doc(updatedDhikr.id)
          .update(updatedDhikr.toMap());

      int index = dhikrs.indexWhere((dhikr) => dhikr.id == updatedDhikr.id);
      if (index != -1) {
        dhikrs[index] = updatedDhikr;
        dhikrs.refresh();
      }

      dhikrs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
  }

  Future<void> _deleteDhikrFromFirestore(Dhikr dhikr) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .doc(dhikr.id)
          .delete();
    }
  }

  Future<bool> canAddDhikr() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .get();

      return snapshot.docs.length <= 5;
    }

    return false;
  }

  Future<void> _addDhikrToFirestore(Dhikr dhikr) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .add(dhikr.toMap());
    }
  }

  Future<void> _fetchDhikrsFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Dhikr> fetchedDhikrs = snapshot.docs.map((doc) {
        return Dhikr.fromDocument(doc);
      }).toList();

      // Sort by lastCount or timestamp to have the most recent first
      fetchedDhikrs.sort((a, b) {
        return b.timestamp
            .compareTo(a.timestamp); // Sort by timestamp in descending order
      });

      dhikrs.assignAll(fetchedDhikrs);
    }
  }

  bool validateTitle() {
    if (title.value.isEmpty) {
      titleError.value = StringConstants.addDhikrTitleError;
      return false;
    } else if (title.value.length > 50) {
      titleError.value = StringConstants.addDhikrTitleLongError;
      return false;
    }
    titleError.value = '';
    return true;
  }

  bool validatePray() {
    if (pray.value.length > 120) {
      prayError.value = StringConstants.addDhikrPrayError;
      return false;
    }
    titleError.value = '';
    return true;
  }

  bool validateTotalCount() {
    final count = int.tryParse(totalCount.value) ?? -1;
    if (count <= 0) {
      totalCountError.value = StringConstants.addDhikrCountZeroError;
      return false;
    } else if (count > 9999) {
      totalCountError.value = StringConstants.addDhikrCountTooBigError;
      return false;
    }
    totalCountError.value = '';
    return true;
  }

  bool validateAll() {
    final isTitleValid = validateTitle();
    final isTotalCountValid = validateTotalCount();
    final isPrayValid = validatePray();
    return isTitleValid && isTotalCountValid && isPrayValid;
  }
}
