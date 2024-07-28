import 'package:get/get.dart';
import 'package:tesbih_app/Resources/picker_colors.dart';
import 'dhikr_list_item_view.dart';

class DhikrsViewModel extends GetxController {
  var beadColor = premiumPickerColors["darkorange"]!.obs;
  var stringColor = premiumPickerColors["gray"]!.obs;
  var backgroundColor = premiumPickerColors["dimgray"]!.obs;

  var dhikrs = <DhikrListItemView>[].obs;
  var title = ''.obs;
  var totalCount = ''.obs;

  var titleError = ''.obs;
  var totalCountError = ''.obs;

  void addDhikr(DhikrListItemView dhikr) {
    dhikrs.add(dhikr);
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
