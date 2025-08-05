import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';
import 'package:echo/src/features/posts/model/comment.dart';
import 'package:echo/src/features/posts/model/post.dart';
import 'package:echo/src/features/posts/views/widgets/floating_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Post post;
  final List<Comment> comments;

  const CommentsBottomSheet({
    super.key,
    required this.post,
    required this.comments,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  late List<Comment> _comments;
  String? _replyingToCommentId;
  String? _replyingToUsername;
  bool commentLiked = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
    _commentFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.removeListener(_handleFocusChange);
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isKeyboardVisible = _commentFocusNode.hasFocus;
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final Comment newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      username: "You", // Replace with actual current user
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
      userGender: Gender.male, // Replace with actual current user gender
      parentCommentId: _replyingToCommentId,
    );

    setState(() {
      if (_replyingToCommentId == null) {
        // Top-level comment
        _comments.add(newComment);
      } else {
        // Reply to existing comment
        _addReplyToComment(_replyingToCommentId!, newComment);
      }
      _commentController.clear();
      _replyingToCommentId = null;
      _replyingToUsername = null;
    });

    _commentFocusNode.unfocus();
  }

  void _addReplyToComment(String parentId, Comment reply) {
    for (int i = 0; i < _comments.length; i++) {
      if (_comments[i].id == parentId) {
        _comments[i] = _comments[i].addReply(reply);
        return;
      }
      // Check nested replies
      _addReplyToNestedComment(_comments[i], parentId, reply);
    }
  }

  void _addReplyToNestedComment(
    Comment comment,
    String parentId,
    Comment reply,
  ) {
    for (int i = 0; i < comment.replies.length; i++) {
      if (comment.replies[i].id == parentId) {
        comment.replies[i] = comment.replies[i].addReply(reply);
        return;
      }
      _addReplyToNestedComment(comment.replies[i], parentId, reply);
    }
  }

  void _startReply(Comment comment) {
    setState(() {
      _replyingToCommentId = comment.id;
      _replyingToUsername = comment.username;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToUsername = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Header (same as before)
          Container(
            padding: PaddingConstants.medium,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Comments',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: context.colorScheme.onSurface),
                ),
              ],
            ),
          ),

          // Comments List (same as before)
          Expanded(
            child:
                _comments.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: context.colorScheme.onSurface.withOpacity(
                              0.5,
                            ),
                          ),
                          const Gap(16),
                          Text(
                            'No comments yet',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Text(
                            'Be the first to comment!',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: PaddingConstants.medium,
                      itemCount: _comments.length,
                      itemBuilder:
                          (BuildContext context, int index) => CommentTile(
                            comment: _comments[index],
                            onReply: _startReply,
                            onLike: (Comment comment) {
                              setState(() {
                                commentLiked = !commentLiked;
                                if (commentLiked) {
                                  comment.likes++;
                                } else {
                                  comment.likes--;
                                }
                              });
                            },
                          ),
                    ),
          ),

          // Reply indicator (shown regardless of keyboard state)
          if (_replyingToCommentId != null && !_isKeyboardVisible)
            Container(
              padding: PaddingConstants.small,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.reply,
                    size: 16,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                  const Gap(8),
                  Text(
                    'Replying to $_replyingToUsername',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

          // Floating input field that appears above keyboard
          if (_isKeyboardVisible)
            Column(
              children: [
                // Show reply indicator above the input when keyboard is visible
                if (_replyingToCommentId != null)
                  Container(
                    padding: PaddingConstants.small,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.reply,
                          size: 16,
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                        const Gap(8),
                        Text(
                          'Replying to $_replyingToUsername',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _cancelReply,
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Container(
                    padding: PaddingConstants.medium,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: context.colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildInputField(),
                  ),
                ),
              ],
            ),

          // Regular input field (shown when keyboard is not visible)
          if (!_isKeyboardVisible)
            Container(
              padding: PaddingConstants.medium,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: _buildInputField(),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 16,
          backgroundImage: Image.asset(AppImages.profileImage).image,
        ),
        const Gap(12),
        Expanded(
          child: TextField(
            controller: _commentController,
            focusNode: _commentFocusNode,
            decoration: InputDecoration(
              hintText:
                  _replyingToCommentId == null
                      ? 'Add a comment...'
                      : 'Reply to $_replyingToUsername...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        const Gap(8),
        IconButton(
          onPressed: _addComment,
          icon: Icon(Icons.send, color: context.colorScheme.primary),
        ),
      ],
    );
  }
}

// Keep the CommentTile class exactly as it was before
// Keep the CommentTile class exactly as it was before
class CommentTile extends StatefulWidget {
  final Comment comment;
  final Function(Comment) onReply;
  final Function(Comment) onLike;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onLike,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _showReplies = false;
  int _repliesCount = 0;
  bool liked = false;
  bool unLiked = false;
  final GlobalKey _upArrowKey = GlobalKey();
  final GlobalKey _downArrowKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _repliesCount =
        widget.comment.replies.length > 5 ? 5 : widget.comment.replies.length;
  }

  void toggleReplies() {
    setState(() {
      _showReplies = !_showReplies;
      if (!_showReplies) {
        _repliesCount =
            widget.comment.replies.length > 5
                ? 5
                : widget.comment.replies.length;
      }
    });
  }

  void loadMoreReplies() {
    setState(() {
      _repliesCount += 5;
      if (_repliesCount >= widget.comment.replies.length) {
        _repliesCount = widget.comment.replies.length;
      }
    });
  }

  void _showFloatingChip(String text, bool isUp) {
    final GlobalKey targetKey = isUp ? _upArrowKey : _downArrowKey;
    final RenderBox? renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final OverlayState overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => FloatingChip(
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
          widget.comment.likes += 1;
          unLiked = false;
        }
        widget.comment.likes += 1;
        liked = true;
        _showFloatingChip("Aura +", true);
      } else {
        widget.comment.likes -= 1;
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
          widget.comment.likes -= 1;
          liked = false;
        }
        widget.comment.likes -= 1;
        unLiked = true;
        _showFloatingChip("Aura -", false);
      } else {
        widget.comment.likes += 1;
        unLiked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(left: widget.comment.depth * 24.0, bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: widget.comment.depth > 0 ? 14 : 18,
              backgroundImage: Image.asset(widget.comment.profilePic).image,
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        widget.comment.username,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.comment.userGender != Gender.other)
                        SizedBox(
                          height: 20,
                          child: Chip(
                            padding: const EdgeInsets.only(bottom: 12),
                            label: Text(
                              widget.comment.userGender == Gender.male
                                  ? 'M'
                                  : 'F',
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      const Gap(8),
                      Text(
                        widget.comment.timeAgo,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    widget.comment.content,
                    style: context.textTheme.bodyMedium,
                  ),
                  const Gap(8),
                  Row(
                    children: <Widget>[
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
                      Text('${widget.comment.likes}'),
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
                      const Gap(16),
                      GestureDetector(
                        onTap: () => widget.onReply(widget.comment),
                        child: Text(
                          'Reply',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (widget.comment.replies.isNotEmpty) ...<Widget>[
                        const Gap(16),
                        GestureDetector(
                          onTap: toggleReplies,
                          child: Text(
                            _showReplies ?  'Hide replies':'View replies' ,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(8),
        // Render replies
        if (_showReplies && widget.comment.replies.isNotEmpty)
          Column(
            children: <Widget>[
              ...widget.comment.replies
                  .take(_repliesCount)
                  .map(
                    (Comment reply) => CommentTile(
                      comment: reply,
                      onReply: widget.onReply,
                      onLike: widget.onLike,
                    ),
                  ),
              if (_repliesCount < widget.comment.replies.length)
                Padding(
                  padding: PaddingConstants.defaultPadding,
                  child: TextButton(
                    onPressed: loadMoreReplies,
                    child: Text(
                      'Show more replies',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}
