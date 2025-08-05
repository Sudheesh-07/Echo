import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';
import 'package:echo/src/features/posts/model/comment.dart';
import 'package:echo/src/features/posts/model/post.dart';
import 'package:echo/src/features/posts/views/widgets/comments_bottom_sheet.dart';
import 'package:echo/src/features/posts/views/widgets/floating_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  bool liked = false;
  bool unLiked = false;

  // Keys for getting widget positions
  final GlobalKey _upArrowKey = GlobalKey();
  final GlobalKey _downArrowKey = GlobalKey();

  void _showCommentsBottomSheet(BuildContext context) {
    // Sample comments for demo - replace with actual data
    final sampleComments = [
      Comment(
        id: '1',
        postId: widget.post.id,
        username: 'Alice',
        content: 'Great post! Really enjoyed reading this.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 5,
        userGender: Gender.female,
        replies: [
          Comment(
            id: '2',
            postId: widget.post.id,
            username: 'Bob',
            content: 'I agree with Alice!',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            likes: 2,
            userGender: Gender.male,
            parentCommentId: '1',
            depth: 1,
          ),
        ],
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
      Comment(
        id: '3',
        postId: widget.post.id,
        username: 'Charlie',
        content: 'Thanks for sharing your thoughts on this topic.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 3,
        userGender: Gender.male,
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) =>
              CommentsBottomSheet(post: widget.post, comments: sampleComments),
    );
  }

  void _showFloatingChip(String text, bool isUp) {
    final GlobalKey targetKey = isUp ? _upArrowKey : _downArrowKey;
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => FloatingChip(
            text: text,
            isUp: isUp,
            startPosition: Offset(
              position.dx + size.width / 2,
              position.dy + size.height / 2,
            ),
            onComplete: () => overlayEntry.remove(),
          ),
    );

    overlay.insert(overlayEntry);
  }

  void _toggleLike() {
    HapticFeedback.selectionClick();
    setState(() {
      if (!liked) {
        if (unLiked) {
          widget.post.likes += 1;
          unLiked = false;
        }
        widget.post.likes += 1;
        liked = true;
        _showFloatingChip("Aura +", true);
      } else {
        widget.post.likes -= 1;
        liked = false;
      }
    });
  }

  Future<void> _toggleUnlike() async {
  await HapticFeedback.heavyImpact();
  
  // Small delay
  await Future.delayed(const Duration(milliseconds: 30));
  
  // Medium vibration
  await HapticFeedback.vibrate();
  
  // Small delay
  await Future.delayed(const Duration(milliseconds: 20));
  
  // Final light click
  await HapticFeedback.lightImpact();
    setState(() {
      if (!unLiked) {
        if (liked) {
          widget.post.likes -= 1;
          liked = false;
        }
        widget.post.likes -= 1;
        unLiked = true;
        _showFloatingChip("Aura -", false);
      } else {
        widget.post.likes += 1;
        unLiked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        color: context.colorScheme.surface,
        padding: PaddingConstants.small,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.asset(widget.post.profilePic).image,
                ),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Gap(5),
                    if (widget.post.visibility != PostVisibility.everyone)
                      SizedBox(
                        height: 25,
                        child: Chip(
                          padding: PaddingConstants.defaultPadding.copyWith(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 10,
                          ),
                          label: Text(
                            widget.post.visibility.name.toUpperCase(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    const Gap(5),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.post.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (widget.post.userGender != Gender.other)
                          SizedBox(
                            height: 20,
                            child: Chip(
                              padding: const EdgeInsets.only(bottom: 12),
                              label: Text(
                                widget.post.userGender == Gender.male
                                    ? "M"
                                    : "F",
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      widget.post.timeAgo,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(10),
            Text(widget.post.title, style: context.textTheme.titleMedium),
            const Gap(10),
            Text(widget.post.content, style: context.textTheme.bodyMedium),
            const Gap(5),
            if (widget.post.imageUrl != null)
              Padding(
                padding: PaddingConstants.small,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(widget.post.imageUrl!),
                ),
              ),

            Row(
              children: <Widget>[
                const Gap(6),
                GestureDetector(
                  key: _upArrowKey,
                  onTap: _toggleLike,
                  child: Icon(
                    Icons.keyboard_double_arrow_up_rounded,
                    color:
                        liked
                            ? Colors.green[600]
                            : context.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
                const Gap(5),
                Text("${widget.post.likes}"),
                const Gap(5),
                GestureDetector(
                  key: _downArrowKey,
                  onTap: _toggleUnlike,
                  child: Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    color:
                        unLiked
                            ? Colors.red[600]
                            : context.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedComment01,
                    color: context.colorScheme.onPrimary,
                  ),
                  onPressed: () => _showCommentsBottomSheet(context),
                ),
                Text("${widget.post.comments}"),
              ],
            ),
          ],
        ),
      ),
      const Divider(height: 0, thickness: 0.2),
    ],
  );
}
