import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DhikrsScreen/dhikrs_viewmodel.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class DhikrView extends StatelessWidget {
  DhikrView({super.key});

  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final DhikrsViewModel dhikrsViewModel = Get.put(DhikrsViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: beadsViewModel.backgroundColor.value,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => dhikrsViewModel.addDhikr(),
              icon: Icon(
                Icons.add_rounded,
                color: getTextColor(beadsViewModel.backgroundColor.value),
              ),
              iconSize: 28,
            )
          ],
          backgroundColor: beadsViewModel.backgroundColor.value,
          title: Text(
            'Dhikrs',
            style: TextStyle(
              fontSize: 24,
              color: getTextColor(beadsViewModel.backgroundColor.value),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: const [
                  DhikrListItemView(
                    title: 'İşe girme duası',
                    lastCount: '23',
                    dhikrCount: "99",
                    backgroundColor: Colors.deepOrangeAccent,
                    beadsColor: Colors.white,
                    stringColor: Colors.black,
                  ),
                  DhikrListItemView(
                    title: 'Nazar duası',
                    lastCount: '0',
                    dhikrCount: "999",
                    backgroundColor: Colors.amberAccent,
                    beadsColor: Colors.black,
                    stringColor: Colors.white,
                  ),
                  DhikrListItemView(
                    title: 'İlişki duasıasdasdadasdasdasasdasdasdasd',
                    lastCount: '11',
                    dhikrCount: "100",
                    backgroundColor: Color.fromARGB(255, 199, 39, 39),
                    beadsColor: Colors.white,
                    stringColor: Colors.lightGreenAccent,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class DhikrListItemView extends StatelessWidget {
  const DhikrListItemView({
    required this.title,
    super.key,
    required this.lastCount,
    required this.dhikrCount,
    required this.stringColor,
    required this.beadsColor,
    required this.backgroundColor,
  });

  final String title;
  final String lastCount;
  final String dhikrCount;
  final Color stringColor;
  final Color beadsColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: getTextColor(backgroundColor),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      "$lastCount/$dhikrCount",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: getTextColor(backgroundColor),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 42.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 3,
                    color: stringColor,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: beadsColor,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: beadsColor,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: beadsColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
