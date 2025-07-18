import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/features/authentication/view/menu.dart';
import 'package:echo/src/features/authentication/view/default_home.dart';
import 'package:echo/src/features/home/view/home_screen.dart';
import 'package:echo/src/features/home/view/settings/about_us.dart';
import 'package:echo/src/features/home/view/settings/edit_profile.dart';
import 'package:echo/src/features/home/view/settings/feedback.dart';
import 'package:echo/src/features/home/view/settings/tnc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  MenuItem selectedItem = MenuItems.home;
  @override
  Widget build(BuildContext context) => ZoomDrawer(
    mainScreen: getScreen(),
    menuScreen: Builder(
      builder: (BuildContext context) => Menu(
          currentItem: selectedItem,
          onSelectedItem: (MenuItem item) {
            setState(() {
              selectedItem = item;
              ZoomDrawer.of(context)!.close();
            });
          },
        ),
    ),
    menuBackgroundColor: context.colorScheme.surface,
    mainScreenScale: 0.15,
    showShadow: true,
    shadowLayer1Color: context.colorScheme.primary.withOpacity(0.3),
    shadowLayer2Color: context.colorScheme.primary.withOpacity(0.4),
    borderRadius: 24,
    angle: -8,
    slideWidth: 300,
    drawerShadowsBackgroundColor: context.colorScheme.surface,
  );
  Widget getScreen() {
    switch (selectedItem) {
      case MenuItems.home:
        return const HomeScreen();
      case MenuItems.editProfile:
        return const EditProfile();
      case MenuItems.aboutUs:
        return const AboutUs();
      case MenuItems.feedback:
        return const UserFeedback();
      case MenuItems.tnc:
        return const TermsAndConditions();
      default:
        return const HomeScreen();
    }
  }
}
