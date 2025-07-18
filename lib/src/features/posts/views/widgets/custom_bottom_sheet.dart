import 'package:echo/src/core/extensions/context_extension.dart';
import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/core/utils/constants/padding_constants.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';
import 'package:echo/src/features/posts/model/post.dart';
import 'package:echo/src/features/posts/model/comment.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
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
        children: [
          // Header
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
              children: [
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

          // Comments List
          Expanded(
            child:
                _comments.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                      itemBuilder: (context, index) {
                        return CommentTile(
                          comment: _comments[index],
                          onReply: _startReply,
                          onLike: (comment) {
                            setState(() {
                              comment.likes++;
                            });
                          },
                        );
                      },
                    ),
          ),

          // Reply indicator
          if (_replyingToCommentId != null)
            Container(
              padding: PaddingConstants.small,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
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

          // Comment Input
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
            child: Row(
              children: [
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
                      filled: true,
                      fillColor: context.colorScheme.surfaceVariant,
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
            ),
          ),
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: comment.depth * 24.0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: comment.depth > 0 ? 14 : 18,
                backgroundImage: Image.asset(comment.profilePic).image,
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (comment.userGender != Gender.other)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  comment.userGender == Gender.male
                                      ? Colors.blue[100]
                                      : Colors.pink[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              comment.userGender == Gender.male ? "M" : "F",
                              style: context.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        const Gap(8),
                        Text(
                          comment.timeAgo,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Text(comment.content, style: context.textTheme.bodyMedium),
                    const Gap(8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => onLike(comment),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const Gap(4),
                              Text(
                                '${comment.likes}',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        GestureDetector(
                          onTap: () => onReply(comment),
                          child: Text(
                            'Reply',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (comment.replies.isNotEmpty) ...[
                          const Gap(16),
                          Text(
                            '${comment.totalReplyCount} ${comment.totalReplyCount == 1 ? 'reply' : 'replies'}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
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

          // Render replies
          if (comment.replies.isNotEmpty)
            Column(
              children:
                  comment.replies.map((reply) {
                    return CommentTile(
                      comment: reply,
                      onReply: onReply,
                      onLike: onLike,
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
