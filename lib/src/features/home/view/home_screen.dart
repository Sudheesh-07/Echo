import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';
import 'package:echo/src/features/posts/model/post.dart';
import 'package:echo/src/features/posts/views/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hugeicons/hugeicons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Post> posts = <Post>[
    Post(
      id: "1",
      title: 'Welcome to Echo',
      username: "John Doe",
      content: "This post is for everyone!",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 24,
      comments: 5,
      userGender: Gender.male,
      visibility: PostVisibility.everyone,
    ),
    Post(
      id: "2",
      title: 'Test',
      username: "Jane Smith",
      imageUrl: 'https://the-artifice.com/wp-content/uploads/2023/04/musashi.jpg',
      content: "Community Only Post",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 42,
      comments: 12,
      userGender: Gender.female,
      visibility: PostVisibility.community,
    ),
    Post(
      id: "3",
      title: 'Image Test',
      imageUrl: 'https://i.ytimg.com/vi/dLjKGF-ykXo/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDnEIrl1BCvF3Y-L2Jmg6y7CisbXQ',
      username: "Alice Johnson",
      content: "Community Only Post",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 42,
      comments: 12,
      userGender: Gender.female,
      visibility: PostVisibility.community,
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Echo'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedMenu01,
          size: 32,
          color: context.colorScheme.primary,
        ),
      ),
    ),
    body: ListView.builder(
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder:
          (BuildContext context, int index) => PostCard(post: posts[index]),
    ),
  );
}
