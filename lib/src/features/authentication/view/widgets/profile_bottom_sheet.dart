import 'dart:developer';
import 'dart:io';
import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/routes/app_routes.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/core/utils/widgets/elevated_button.dart';
import 'package:echo/src/features/authentication/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Gender Enum to no mess up things
enum Gender {
  ///for Male
  male,

  ///for Female
  female,

  /// for other genders
  other,
}

/// This is the profile bottom sheet that pops up to enter user info
class ProfileBottomSheet extends StatefulWidget {
  /// Constructor
  const ProfileBottomSheet({required this.username, super.key});

  /// This is the random user name that we get from the api
  final String username;

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  String? _errorMessage;
  Gender _selectedGender = Gender.male;
  @override
  void initState() {
    usernameController.text = widget.username;
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Reduce quality for smaller file size
        maxWidth: 800, // Limit dimensions
      );

      if (image != null) {
        // Validate image size (example: 5MB limit)
        final File file = File(image.path);
        final int sizeInBytes = await file.length();
        const int maxSize = 5 * 1024 * 1024; // 5MB

        if (sizeInBytes > maxSize) {
          setState(() {
            _errorMessage = 'Image size should be less than 5MB';
          });
          return;
        }

        setState(() {
          _selectedImage = image;
          _errorMessage = null;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
      debugPrint('Image picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: PaddingConstants.defaultPadding,
    width: context.width,
    height: 550,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          context.colorScheme.primary,
          context.colorScheme.surface,
        ],
      ),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Gap(25),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.onPrimary,
                      width: 10,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:
                        _selectedImage != null
                            ? Image.file(
                              File(_selectedImage!.path),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) => Image.asset(
                                    AppImages.profileImage,
                                    height: 150,
                                    width: 150,
                                  ),
                            )
                            : Image.asset(
                              AppImages.profileImage,
                              height: 150,
                              width: 150,
                            ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colorScheme.onPrimary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: context.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_errorMessage != null) ...<Widget>[
            const Gap(10),
            Center(
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: context.colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const Gap(20),
          Text('Username', style: context.textTheme.titleLarge),
          const Gap(10),
          TextFormField(key: _formKey, controller: usernameController),
          const Gap(20),
          Text('Gender', style: context.textTheme.titleLarge),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              radioButton(Gender.male, 'Male'),
              radioButton(Gender.female, 'Female'),
              radioButton(Gender.other, 'Other'),
            ],
          ),
          const Gap(10),
          EchoButton(
            label: 'Save',
            onPressed:
                () => context.read<AuthCubit>().registerUser(
                  usernameController.text,
                  _selectedGender.name,
                  _selectedImage ?? XFile(AppImages.profileImage),
                ),
          ),
        ],
      ),
    ),
  );
  Widget radioButton(Gender value, String label) => Row(
    children: <Widget>[
      Radio<Gender>(
        activeColor: context.colorScheme.secondary,
        value: value,
        groupValue: _selectedGender,
        onChanged: (Gender? value) {
          setState(() {
            _selectedGender = value!;
            log(_selectedGender.name);
          });
        },
      ),
      Text(label, style: context.textTheme.bodyLarge),
    ],
  );
}
