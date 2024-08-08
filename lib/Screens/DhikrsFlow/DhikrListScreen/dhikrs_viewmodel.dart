import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbih_app/Models/dhikr_model.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';

class DhikrsViewModel extends GetxController {
  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  var dhikrs = <Dhikr>[].obs;
  var title = ''.obs;
  var totalCount = ''.obs;

  var titleError = ''.obs;
  var totalCountError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDhikrsFromFirestore();
  }

  void addDhikr(Dhikr dhikr) {
    dhikrs.add(dhikr);
    _addDhikrToFirestore(dhikr);
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

      dhikrs.assignAll(fetchedDhikrs);
    }
  }

  bool validateTitle() {
    if (title.value.isEmpty) {
      titleError.value = 'Title cannot be empty';
      return false;
    }
    titleError.value = '';
    return true;
  }

  bool validateTotalCount() {
    final count = int.tryParse(totalCount.value) ?? -1;
    if (count <= 0) {
      totalCountError.value = 'Total count must be greater than 0';
      return false;
    }
    totalCountError.value = '';
    return true;
  }

  bool validateAll() {
    final isTitleValid = validateTitle();
    final isTotalCountValid = validateTotalCount();
    return isTitleValid && isTotalCountValid;
  }
}
