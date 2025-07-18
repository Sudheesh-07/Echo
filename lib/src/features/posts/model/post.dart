import 'package:echo/src/core/extensions/image_extensions.dart';
import 'package:echo/src/features/authentication/view/widgets/profile_bottom_sheet.dart';

class Post {
  final String id;
  final String title;
  final String username;
  final String profilePic;
  final String content;
  final DateTime createdAt;
  int likes;
  int comments;
  final String? imageUrl;
  final Gender userGender;
  final PostVisibility visibility;

  Post({
    required this.id,
    required this.title,
    required this.username,
    this.profilePic = AppImages.profileImage,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.imageUrl,
    required this.userGender,
    required this.visibility,
  });
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inDays > 0) return "${difference.inDays}d ago";
    if (difference.inHours > 0) return "${difference.inHours}h ago";
    return "${difference.inMinutes}m ago";
  }
}

enum PostVisibility {
  everyone, // Visible to all
  community, // Only visible to community members
}
