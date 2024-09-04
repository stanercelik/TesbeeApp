import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesbih_app/Constants/string_constants.dart';
import 'package:tesbih_app/Resources/app_colors.dart';
import 'package:tesbih_app/Screens/Authflow/BaseAuth/base_auth_viewmodel.dart';
import 'package:tesbih_app/Screens/BeadsScreen/beads_viewmodel.dart';
import 'package:tesbih_app/Screens/DraggableCycleView/draggable_cycle.dart';
import 'package:tesbih_app/Utils/color_picker_utils.dart';
import 'package:tesbih_app/Utils/color_utils.dart';

class BeadsView extends StatelessWidget {
  final BeadsViewModel beadsViewModel = Get.put(BeadsViewModel());
  final UserAuthViewModel authViewModel = Get.put(UserAuthViewModel());

  BeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double padding =
        screenSize.width * 0.05; // 5% of screen width as padding

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primaryBackground,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: getTextColor(AppColors.primaryBackground),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            StringConstants.mainScreenAppTitle,
            style: TextStyle(
              fontSize: screenSize.width * 0.06, // 6% of screen width
              color: getTextColor(AppColors.primaryBackground),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.primaryBackground,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: screenSize.height * 0.2, // 20% of screen height
                child: DrawerHeader(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(color: Colors.black)],
                    color: AppColors.primaryBackground,
                  ),
                  child: Text(
                    StringConstants.drawerTitle,
                    style: TextStyle(
                      color: getTextColor(AppColors.primaryBackground),
                      fontSize: screenSize.width * 0.07, // 7% of screen width
                    ),
                  ),
                ),
              ),
              _buildListTile(
                context: context,
                title: StringConstants.drawerChangeBeadsColor,
                color: beadsViewModel.beadColor.value,
                onTap: () {
                  showColorPicker(
                    context,
                    beadsViewModel.changeBeadColor,
                    beadsViewModel.beadColor.value,
                  );
                },
              ),
              _buildListTile(
                context: context,
                title: StringConstants.drawerChangeStringColor,
                color: beadsViewModel.stringColor.value,
                onTap: () {
                  showColorPicker(
                    context,
                    beadsViewModel.changeStringColor,
                    beadsViewModel.stringColor.value,
                  );
                },
              ),
              _buildSwitchTile(
                context: context,
                icon: Icons.vibration_rounded,
                title: StringConstants.drawerVibration,
                value: beadsViewModel.isVibration.value,
                onChanged: beadsViewModel.toggleVibration,
                activeColor: beadsViewModel.beadColor.value,
              ),
              _buildSwitchTile(
                context: context,
                icon: Icons.volume_up_rounded,
                title: StringConstants.drawerSoundEffect,
                value: beadsViewModel.isSoundEffect.value,
                onChanged: beadsViewModel.toggleSoundEffect,
                activeColor: beadsViewModel.beadColor.value,
              ),
              authViewModel.isUserSignedIn()
                  ? ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        color: getTextColor(AppColors.primaryBackground),
                      ),
                      title: Text(
                        StringConstants.drawerSignOut,
                        style: TextStyle(
                          color: getTextColor(AppColors.primaryBackground),
                        ),
                      ),
                      onTap: authViewModel.signOut,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: DraggableCircle(
                  stringColor: beadsViewModel.stringColor.value,
                  beadColor: beadsViewModel.beadColor.value,
                  totalCount: 99,
                  lastCount: beadsViewModel.lastCount,
                  viewModel: beadsViewModel,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => Container(
                  height: screenSize.height * 0.1, // 10% of screen height
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        invertColor(getTextColor(AppColors.primaryBackground))
                            .withOpacity(0.7),
                        invertColor(getTextColor(AppColors.primaryBackground))
                            .withAlpha(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${beadsViewModel.lastCount}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.08, // 8% of screen width
                          color: getTextColor(AppColors.primaryBackground),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        beadsViewModel.currentText.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.06, // 6% of screen width
                          color: getTextColor(AppColors.primaryBackground),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a list tile for color change
  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
          border: Border.all(
            width: 1,
            color: getTextColor(color),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: getTextColor(AppColors.primaryBackground),
        ),
      ),
      onTap: onTap,
    );
  }

  // Helper method to create a switch tile
  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color activeColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: getTextColor(AppColors.primaryBackground)),
      trailing: Switch(
        activeColor: activeColor,
        value: value,
        onChanged: onChanged,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: getTextColor(AppColors.primaryBackground),
        ),
      ),
    );
  }
}
