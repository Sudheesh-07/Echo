import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hugeicons/hugeicons.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedMenu01,
          size: 32,
          color: context.colorScheme.primary,
        ),
      ),
      ),
    );
}