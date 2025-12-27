/// User info model for profile management.
class UserInfo {
  final String id;
  final String? email;
  final String? mobile;
  final String username;
  final String? avatarUrl;
  final String createdAt;
  final String updatedAt;
  final String? clientLastLoginAt;

  const UserInfo({
    required this.id,
    this.email,
    this.mobile,
    required this.username,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.clientLastLoginAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      clientLastLoginAt: json['clientLastLoginAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'username': username,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'clientLastLoginAt': clientLastLoginAt,
    };
  }

  UserInfo copyWith({
    String? id,
    String? email,
    String? mobile,
    String? username,
    String? avatarUrl,
    String? createdAt,
    String? updatedAt,
    String? clientLastLoginAt,
  }) {
    return UserInfo(
      id: id ?? this.id,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientLastLoginAt: clientLastLoginAt ?? this.clientLastLoginAt,
    );
  }
}
