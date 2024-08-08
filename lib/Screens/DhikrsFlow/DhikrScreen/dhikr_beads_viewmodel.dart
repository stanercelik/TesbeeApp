import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tesbih_app/Models/dhikr_model.dart';
import 'package:tesbih_app/Screens/DraggableCycleView/draggable_cycle_view_model.dart';

class DhikrBeadsViewModel extends DraggableCycleViewModel {
  final Dhikr dhikr;

  DhikrBeadsViewModel({required this.dhikr}) {
    lastCount.value = dhikr.lastCount;
  }

  var lastCount = 0.obs;

  @override
  void increment() {
    playSoundAndVibrate();
    if (lastCount.value < int.parse(dhikr.totalCount)) {
      lastCount.value++;
      dhikr.lastCount = lastCount.value;
      updateLastCountInFirestore();
    } else {
      resetCounter();
    }
    updateText();
  }

  @override
  void resetCounter() {
    lastCount.value = 1;
    dhikr.lastCount = 1;
    updateLastCountInFirestore();
    resetPosition();
  }

  void updateLastCountInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dhikrs')
          .doc(dhikr.id)
          .update({'lastCount': dhikr.lastCount});
    }
  }
}
