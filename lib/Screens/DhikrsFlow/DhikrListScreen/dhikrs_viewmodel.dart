import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbee/Models/dhikr_model.dart';
import 'package:tesbee/Models/predefined_dhikr_model.dart';
import 'package:tesbee/Resources/picker_colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DhikrsViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final AppLocalizations l10n;

  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  // Mevcut kullanıcının ID'sini takip etmek için
  var currentUserId = ''.obs;
  var dhikrs = <Dhikr>[].obs;
  var title = ''.obs;
  var totalCount = ''.obs;
  var pray = ''.obs;

  var titleError = ''.obs;
  var totalCountError = ''.obs;
  var prayError = ''.obs;

  final RxList<PredefinedDhikr> predefinedDhikrs = <PredefinedDhikr>[].obs;
  final Rx<PredefinedDhikr?> selectedPredefinedDhikr =
      Rx<PredefinedDhikr?>(null);

  @override
  void onInit() {
    super.onInit();
    l10n = AppLocalizations.of(Get.context!)!;
    // Kullanıcı oturum durumunu dinle
    ever(currentUserId, (_) => _fetchDhikrsFromFirestore());

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        if (currentUserId.value != user.uid) {
          dhikrs.clear(); // Önce mevcut zikirleri temizle
          currentUserId.value = user.uid;
        }
      } else {
        dhikrs.clear();
        currentUserId.value = '';
      }
    });
    loadPredefinedDhikrs();
  }

  Future<void> addDhikr(Dhikr dhikr) async {
    if (currentUserId.value.isEmpty) return;

    DocumentReference docRef = _firestore
        .collection('users')
        .doc(currentUserId.value)
        .collection('dhikrs')
        .doc();

    dhikr.id = docRef.id;
    await docRef.set(dhikr.toMap());
    dhikrs.add(dhikr);
  }

  Future<void> deleteDhikr(Dhikr dhikr) async {
    if (currentUserId.value.isEmpty) return;

    await _deleteDhikrFromFirestore(dhikr);
    dhikrs.remove(dhikr);
  }

  Future<void> updateDhikr(Dhikr updatedDhikr) async {
    if (currentUserId.value.isEmpty) return;

    if (updatedDhikr.id.isNotEmpty) {
      // ID kontrolü eklendi.
      updatedDhikr.timestamp = Timestamp.now();
      await _firestore
          .collection('users')
          .doc(currentUserId.value)
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
    if (currentUserId.value.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(currentUserId.value)
        .collection('dhikrs')
        .doc(dhikr.id)
        .delete();
  }

  Future<bool> canAddDhikr() async {
    if (currentUserId.value.isEmpty) return false;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(currentUserId.value)
        .collection('dhikrs')
        .get();

    return snapshot.docs.length <= 5;
  }

  Future<void> _fetchDhikrsFromFirestore() async {
    if (currentUserId.value.isEmpty) return;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId.value)
          .collection('dhikrs')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Dhikr> fetchedDhikrs = snapshot.docs.map((doc) {
        return Dhikr.fromDocument(doc);
      }).toList();

      dhikrs.assignAll(fetchedDhikrs);
    } catch (e) {
      print('Error fetching dhikrs: $e');
      dhikrs.clear();
    }
  }

  Future<void> loadPredefinedDhikrs() async {
    try {
      print('Loading predefined dhikrs...');
      final String jsonString =
          await rootBundle.loadString('assets/data/dhikrs.json');
      print('JSON loaded: $jsonString');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> dhikrsJson = jsonData['dhikrs'];

      predefinedDhikrs.value =
          dhikrsJson.map((json) => PredefinedDhikr.fromJson(json)).toList();
      print('Predefined dhikrs loaded: ${predefinedDhikrs.length}');
    } catch (e) {
      print('Error loading predefined dhikrs: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  void selectPredefinedDhikr(PredefinedDhikr? dhikr) {
    selectedPredefinedDhikr.value = dhikr;
    if (dhikr != null) {
      title.value = dhikr.title[Get.locale?.languageCode ?? 'en'] ?? '';
      totalCount.value = dhikr.targetCount.toString();
      pray.value = dhikr.transliteration;
    }
  }

  bool validateTitle() {
    if (title.value.isEmpty) {
      titleError.value = l10n.addDhikrTitleError;
      return false;
    } else if (title.value.length > 50) {
      titleError.value = l10n.addDhikrTitleLongError;
      return false;
    }
    titleError.value = '';
    return true;
  }

  bool validatePray() {
    if (pray.value.length > 120) {
      prayError.value = l10n.addDhikrPrayError;
      return false;
    }
    prayError.value = '';
    return true;
  }

  bool validateTotalCount() {
    final count = int.tryParse(totalCount.value) ?? -1;
    if (count <= 0) {
      totalCountError.value = l10n.addDhikrCountZeroError;
      return false;
    } else if (count > 9999) {
      totalCountError.value = l10n.addDhikrCountTooBigError;
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
