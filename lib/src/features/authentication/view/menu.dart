import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/features/authentication/cubit/auth_cubit.dart';
import 'package:echo/src/features/authentication/cubit/auth_state.dart';
import 'package:echo/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class MenuItems {
  static const MenuItem home = MenuItem(
    title: 'Home',
    icon: HugeIcons.strokeRoundedHome09,
  );
  static const MenuItem editProfile = MenuItem(
    title: 'Edit Profile',
    icon: HugeIcons.strokeRoundedEditUser02,
  );
  static const MenuItem aboutUs = MenuItem(
    title: 'About Us',
    icon: HugeIcons.strokeRoundedInformationSquare,
  );
  static const MenuItem tnc = MenuItem(
    title: 'Terms and Conditions',
    icon: HugeIcons.strokeRoundedDocumentAttachment,
  );
  static const MenuItem feedback = MenuItem(
    title: 'Feedback',
    icon: HugeIcons.strokeRoundedEdit02,
  );

  static const List<MenuItem> all = <MenuItem>[
    home,
    editProfile,
    aboutUs,
    feedback,
    tnc,
  ];
}

class Menu extends StatefulWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  const Menu({
    required this.currentItem,
    required this.onSelectedItem,
    super.key,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  UserModel? _currentUser;
  @override
  void initState() {
    _currentUser = context.read<AuthCubit>().state.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colorScheme.surface,
    body: SafeArea(
      child: Column(
        children: <Widget>[
          const Spacer(),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colorScheme.secondary,
                width: 4,
              ),
            ),
            child: CircleAvatar(
              backgroundImage:
                  _currentUser!.profile_image.isNotEmpty == true
                      ? NetworkImage(_currentUser!.profile_image)
                      : null,
              radius: 60,
            ),
          ),
          const Gap(30),
          ...MenuItems.all.map((MenuItem item) => buildItemMenu(item, context)),
          const Spacer(),
          Divider(color: context.colorScheme.outline),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ListTile(
              leading: const Icon(HugeIcons.strokeRoundedLogout01),
              title: const Text('Logout'),
              onTap: () => widget.onSelectedItem(MenuItems.home),
              selected: widget.currentItem == MenuItems.home,
              selectedTileColor: context.colorScheme.primary,
              selectedColor: context.colorScheme.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildItemMenu(MenuItem item, BuildContext context) => Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
    child: ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      onTap: () => widget.onSelectedItem(item),
      selected: widget.currentItem == item,
      selectedTileColor: context.colorScheme.primary,
      selectedColor: context.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
  );
}

class MenuItem {
  const MenuItem({required this.title, required this.icon});
  final String title;
  final IconData icon;
}
