import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tesbee/Components/add_dhikr_color_picker_item.dart';
import 'package:tesbee/Models/dhikr_model.dart';
import 'package:tesbee/Resources/app_colors.dart';
import 'package:tesbee/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbee/Screens/DhikrsFlow/DhikrListScreen/dhikrs_viewmodel.dart';
import 'package:tesbee/Services/ad_service.dart';
import 'package:tesbee/Services/rating_service.dart';
import 'package:tesbee/Utils/color_utils.dart';

class AddDhikrBottomSheet extends StatelessWidget {
  final Dhikr? editDhikr;

  const AddDhikrBottomSheet({Key? key, this.editDhikr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());
    final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
    final AdService adService = Get.put(AdService());

    /// ExpansionTile’in açık/kapalı durumunu yakalamak için kullanabilirsiniz.
    final RxBool isExpanded = false.obs;

    /// TextField controller’ları
    final TextEditingController titleController = TextEditingController();
    final TextEditingController totalCountController = TextEditingController();
    final TextEditingController prayController = TextEditingController();

    /// Edit modundaysak, var olan zikir bilgilerini dolduralım
    if (editDhikr != null) {
      dhikrsViewModel.title.value = editDhikr!.title;
      dhikrsViewModel.totalCount.value = editDhikr!.totalCount.toString();
      dhikrsViewModel.pray.value = editDhikr!.pray;
      dhikrsViewModel.beadColor.value = editDhikr!.beadsColor;
      dhikrsViewModel.stringColor.value = editDhikr!.stringColor;
      dhikrsViewModel.backgroundColor.value = editDhikr!.backgroundColor;

      titleController.text = dhikrsViewModel.title.value;
      totalCountController.text = dhikrsViewModel.totalCount.value;
      prayController.text = dhikrsViewModel.pray.value;
    } else {
      /// Yeni zikir eklerken, başlangıç renklerini atayalım
      dhikrsViewModel.backgroundColor.value = AppColors.primaryBackground;
      dhikrsViewModel.beadColor.value = beadsViewModel.beadColor.value;
      dhikrsViewModel.stringColor.value = beadsViewModel.stringColor.value;
    }

    /// Arkaplan ve yazı renklerini, seçilen renklere göre hesaplayalım
    Color backgroundColor = dhikrsViewModel.backgroundColor.value;
    Color textColor = getTextColor(backgroundColor);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        // SingleChildScrollView kullanarak klavye açıldığında taşma yaşanmasını önleyebiliriz
        child: Column(
          // mainAxisSize: MainAxisSize.min // <-- Kısıtlayıcı özelliği KALDIRILDI
          children: [
            /// ------------------- Hazır Zikirler (ExpansionTile) -------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: textColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      // ExpansionTile’ın iç çizgilerini kaldırmak için
                      dividerColor: Colors.transparent,
                      // Ayrıca isterseniz, çökme/katlanma animasyon renklerini de değiştirebilirsiniz
                    ),
                    child: ExpansionTile(
                      maintainState: true,
                      onExpansionChanged: (expanded) {
                        isExpanded.value = expanded;
                      },
                      iconColor: textColor,
                      collapsedIconColor: textColor,
                      title: Text(
                        l10n.predefinedDhikrs,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dhikrsViewModel.predefinedDhikrs.length,
                            itemBuilder: (context, index) {
                              final predefined =
                                  dhikrsViewModel.predefinedDhikrs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Hazır zikri seçince, text alanlarını dolduruyoruz
                                    dhikrsViewModel
                                        .selectPredefinedDhikr(predefined);
                                    titleController.text = predefined.title[Get.locale?.languageCode ?? 'en'] ?? '';
                                    totalCountController.text =
                                        predefined.targetCount.toString();
                                    prayController.text =
                                        predefined.transliteration;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: textColor.withOpacity(0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      // meaning alanını çekerken, mevcut dil koduna göre alıyoruz
                                      predefined.meaning[
                                              Get.locale?.languageCode ??
                                                  'en'] ??
                                          '',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// ------------------- Zikir Adı TextField -------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Obx(
                () => TextField(
                  controller: titleController,
                  onChanged: (value) {
                    dhikrsViewModel.title.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: l10n.addDhikrTitle,
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                    hintText: l10n.addDhikrTitleHint,
                    errorText: dhikrsViewModel.titleError.value.isNotEmpty
                        ? dhikrsViewModel.titleError.value
                        : null,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  cursorColor: beadsViewModel.beadColor.value,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),

            /// ------------------- Hedef Sayısı TextField -------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Obx(
                () => TextField(
                  controller: totalCountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    dhikrsViewModel.totalCount.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: l10n.addDhikrTargetNum,
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                    hintText: l10n.addDhikrTargetNumHint,
                    errorText: dhikrsViewModel.totalCountError.value.isNotEmpty
                        ? dhikrsViewModel.totalCountError.value
                        : null,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  cursorColor: beadsViewModel.beadColor.value,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),

            /// ------------------- Dua / Metin TextField -------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Obx(
                () => TextField(
                  controller: prayController,
                  maxLines: 3,
                  maxLength: 120,
                  onChanged: (value) {
                    dhikrsViewModel.pray.value = value;
                  },
                  decoration: InputDecoration(
                    labelText: l10n.addDhikrPray,
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                    hintText: l10n.addDhikrPrayHint,
                    errorText: dhikrsViewModel.prayError.value.isNotEmpty
                        ? dhikrsViewModel.prayError.value
                        : null,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  cursorColor: beadsViewModel.beadColor.value,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),

            /// ------------------- Renk Seçiciler -------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Tane Rengi
                  Expanded(
                    child: ColorPickerRow(
                      text: l10n.addDhikrBeadsColor,
                      color: dhikrsViewModel.beadColor,
                      onColorChanged: (color) {
                        dhikrsViewModel.beadColor.value = color;
                      },
                      textColor: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// İp Rengi
                  Expanded(
                    child: ColorPickerRow(
                      text: l10n.addDhikrStringColor,
                      color: dhikrsViewModel.stringColor,
                      onColorChanged: (color) {
                        dhikrsViewModel.stringColor.value = color;
                      },
                      textColor: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Arkaplan Rengi
                  Expanded(
                    child: ColorPickerRow(
                      text: l10n.addDhikrBackgroundColor,
                      color: dhikrsViewModel.backgroundColor,
                      onColorChanged: (color) {
                        dhikrsViewModel.backgroundColor.value = color;
                      },
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
            ),

            /// ------------------- Kaydet/ Güncelle Butonu -------------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: beadsViewModel.beadColor.value,
                  ),
                  onPressed: () {
                    /// Tüm validasyonları kontrol edelim
                    if (dhikrsViewModel.validateAll()) {
                      /// Yeni ya da güncellenecek Dhikr modelini hazırlıyoruz
                      final updatedDhikr = Dhikr(
                        id: editDhikr?.id ?? '',
                        title: dhikrsViewModel.title.value,
                        beadsColor: dhikrsViewModel.beadColor.value,
                        stringColor: dhikrsViewModel.stringColor.value,
                        backgroundColor: dhikrsViewModel.backgroundColor.value,
                        totalCount: dhikrsViewModel.totalCount.value,
                        lastCount: editDhikr?.lastCount ?? 0,
                        pray: dhikrsViewModel.pray.value,
                        timestamp: Timestamp.now(),
                      );

                      if (editDhikr != null) {
                        // Düzenleme modundaysak:
                        dhikrsViewModel.updateDhikr(updatedDhikr);
                        Navigator.pop(context);
                        adService.showInterstitialAd();
                      } else {
                        // Yeni ekleme modundaysak:
                        dhikrsViewModel.addDhikr(updatedDhikr);
                        Navigator.pop(context);
                        // Zikir eklendikten bir süre sonra kullanıcıya değerlendirme diyalogu göster
                        Future.delayed(const Duration(milliseconds: 500), () {
                          RatingService.showRatingDialog(context)
                              .then((_) => adService.showInterstitialAd());
                        });
                      }

                      // Ekleme veya güncelleme sonrasında metin alanlarını sıfırlayalım
                      dhikrsViewModel.title.value = "";
                      dhikrsViewModel.totalCount.value = "";
                      dhikrsViewModel.pray.value = "";
                    }
                  },
                  child: Text(
                    editDhikr != null
                        ? l10n.editDhikrButton // "Zikri Düzenle"
                        : l10n.addDhikrButton, // "Zikir Ekle"
                    style: TextStyle(
                      color: getTextColor(beadsViewModel.beadColor.value),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
