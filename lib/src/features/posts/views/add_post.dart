import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late final FocusNode _focusNode;

  @override

  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(title: const Text('Add Post')),
    body: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: PaddingConstants.small,
              child: ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.secondary,
                      width: 4,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: Image.asset(AppImages.profileImage).image,
                    radius: 30,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                style: context.textTheme.titleLarge,
                focusNode: _focusNode,
                autofocus: true,
                decoration:  InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  focusedBorder: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.primaryFixedDim
                  )
                ),
              ),
            ),
          ],
        ),
        TextField(
          style: context.textTheme.bodyLarge,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            focusedBorder: InputBorder.none,
            hintText: 'body (Spill the tea with everyone)',
            hintStyle: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.primaryFixedDim,
            ),
          ),
        ),
        const Spacer(),
        Divider(color: context.colorScheme.primaryFixedDim,),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(HugeIcons.strokeRoundedImage01),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(HugeIcons.strokeRoundedCamera01),
            ),
          ],
        )
      ],
    ),
  );
}
