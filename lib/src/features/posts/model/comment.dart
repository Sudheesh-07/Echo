import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';

class Comment {
  final String id;
  final String postId;
  final String username;
  final String profilePic;
  final String content;
  final DateTime createdAt;
  int likes;
  final Gender userGender;
  final String? parentCommentId; // For nested replies
  final List<Comment> replies; // Nested replies
  final int depth; 
  bool isLiked = false; // How deep the comment is nested (0 for top-level)

  Comment({
    required this.id,
    required this.postId,
    required this.username,
    this.profilePic = AppImages.profileImage,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    required this.userGender,
    this.parentCommentId,
    this.replies = const [],
    this.depth = 0,
    this.isLiked = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inDays > 0) return "${difference.inDays}d ago";
    if (difference.inHours > 0) return "${difference.inHours}h ago";
    if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
    return "now";
  }

  // Copy with method for updating likes
  Comment copyWith({
    String? id,
    String? postId,
    String? username,
    String? profilePic,
    String? content,
    DateTime? createdAt,
    int? likes,
    Gender? userGender,
    String? parentCommentId,
    List<Comment>? replies,
    int? depth,
    bool? isLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      userGender: userGender ?? this.userGender,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
      depth: depth ?? this.depth,
    );
  }

  // Method to add a reply
  Comment addReply(Comment reply) {
    final updatedReplies = [...replies, reply.copyWith(depth: depth + 1)];
    return copyWith(replies: updatedReplies);
  }

  // Method to get total reply count (including nested replies)
  int get totalReplyCount {
    int count = replies.length;
    for (final reply in replies) {
      count += reply.totalReplyCount;
    }
    return count;
  }
}
