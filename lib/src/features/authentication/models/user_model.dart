/// User Model

class UserModel {

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userName: json['userName'] as String ,
      gender: json['gender'] as String ,
      profile_image: json['profile_image'] as String,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  UserModel({
    required this.userName,
    required this.gender,
    required this.profile_image,
    this.updatedAt,
  });

  final String userName;
  final String gender;
  final String profile_image;
  final DateTime? updatedAt;

  /// Method to convert UserModel to JSON
  Map<String, dynamic> toJson() => {
      'userName': userName,
      'gender': gender,
      'profile_image': profile_image,
      'updated_at': updatedAt?.toIso8601String(),
    };
}
